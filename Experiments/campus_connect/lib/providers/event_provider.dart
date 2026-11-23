import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_sync_service.dart';
import '../services/prefs_service.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../utils/error_messages.dart';

class EventProvider extends ChangeNotifier {
  final EventSyncService _service = EventSyncService();
  final PrefsService _prefs = PrefsService();
  StreamSubscription<EventsSnapshot>? _subscription;

  List<Event> _events = [];
  Set<String> _rsvpIds = {}; // my RSVPs
  Set<String> _pendingIds = {};
  bool _fromCache = false;
  bool _isLoading = true;
  String? _error;
  String? _syncError;
  String _searchQuery = '';
  String _category = 'All';
  EventFilter _filter = EventFilter.all;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get syncError => _syncError;
  bool get isOffline => _fromCache;
  String get selectedCategory => _category;
  EventFilter get filter => _filter;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  bool isPending(Event event) => _pendingIds.contains(event.id);

  // RSVP and tabs 
  bool isGoing(Event event) => _rsvpIds.contains(event.id);

  int goingCount(Event event) {
    final inFirestore = event.isAttending(userId);
    final mine = isGoing(event);
    if (mine == inFirestore) return event.rsvpCount;
    return mine ? event.rsvpCount + 1 : event.rsvpCount - 1;
  }

  List<Event> get upcomingEvents {
    final list = _events.where((e) => e.isUpcoming).toList();
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return list;
  }

  List<Event> get myEvents => _events.where(isGoing).toList();

  List<Event> get filteredEvents {
    final result = _events.where((e) {
      final matchesCategory = _category == 'All' || e.category == _category;
      final matchesFilter = _filter == EventFilter.all ||
          (_filter == EventFilter.upcoming && e.isUpcoming) ||
          (_filter == EventFilter.going && e.isAttending(userId));
      return matchesCategory && matchesFilter;
    }).toList();

    result.sort((a, b) {
      if (a.isUpcoming != b.isUpcoming) return a.isUpcoming ? -1 : 1;
      return a.isUpcoming
          ? a.dateTime.compareTo(b.dateTime)
          : b.dateTime.compareTo(a.dateTime);
    });

    return result.search(_searchQuery);
  }

  void listen() {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;

    // Restore the RSVPs saved on this device until Firestore answers
    _prefs.getRsvpIds().then((ids) {
      if (_isLoading) _rsvpIds = ids;
    });

    _subscription = _service.watchEvents().listen(
      (snapshot) {
        _events = snapshot.events;
        _pendingIds = snapshot.pendingIds;
        _fromCache = snapshot.fromCache;
        // The snapshot already includes my pending local writes
        _rsvpIds = snapshot.events
            .where((e) => e.isAttending(userId))
            .map((e) => e.id)
            .toSet();
        _prefs.setRsvpIds(_rsvpIds);
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = friendlyError(error);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void retry() {
    listen();
    notifyListeners();
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _events = [];
    _rsvpIds = {};
    _pendingIds = {};
    _fromCache = false;
    _prefs.setRsvpIds(_rsvpIds);
    _isLoading = true;
    _error = null;
    _syncError = null;
    _searchQuery = '';
    _category = 'All';
    _filter = EventFilter.all;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _category = category;
    notifyListeners();
  }

  void setFilter(EventFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void clearSyncError() {
    _syncError = null;
    notifyListeners();
  }

  // The event shows up at once (marked "Syncing") and is sent when online.
  // We do not wait for the server: offline, Firestore keeps the write queued.
  Future<void> addEvent(Event event) async {
    final id = _service.newEventId(); // made on the device: retry-safe

    _service.createEvent(id, event).catchError((_) {
      _syncError = 'Could not save "${event.title}". It was removed.';
      notifyListeners();
    });
  }

  Future<void> toggleRsvp(Event event) async {
    final going = !isGoing(event);

    // 1. Update the UI immediately
    _setLocalRsvp(event.id, going);
    notifyListeners();
    await _prefs.setRsvpIds(_rsvpIds);

    // 2. Send it; undo only if the server really rejects it
    _service.setRsvp(event.id, userId, going).catchError((_) {
      _setLocalRsvp(event.id, !going);
      _syncError =
          'Could not update your RSVP for "${event.title}". It was undone.';
      notifyListeners();
      _prefs.setRsvpIds(_rsvpIds);
    });
  }

  void _setLocalRsvp(String eventId, bool going) {
    if (going) {
      _rsvpIds.add(eventId);
    } else {
      _rsvpIds.remove(eventId);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
