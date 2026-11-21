import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../services/prefs_service.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = EventService();
  final PrefsService _prefs = PrefsService();
  StreamSubscription<List<Event>>? _subscription;

  List<Event> _events = [];
  Set<String> _rsvpIds = {};
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _category = 'All';
  EventFilter _filter = EventFilter.all;

  static const Duration _writeTimeout = Duration(seconds: 15);

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _category;
  EventFilter get filter => _filter;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

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

  // Task 2
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

    _prefs.getRsvpIds().then((ids) {
      if (_isLoading) _rsvpIds = ids;
    });

    _subscription = _service.getEvents().listen(
      (data) {
        _events = data;
        _rsvpIds =
            data.where((e) => e.isAttending(userId)).map((e) => e.id).toSet();
        _prefs.setRsvpIds(_rsvpIds);
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (_) {
        _error = 'Could not load events. Check your connection and try again.';
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
    _prefs.setRsvpIds(_rsvpIds);
    _isLoading = true;
    _error = null;
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

  Future<void> addEvent(Event event) {
    return _service.addEvent(event).timeout(_writeTimeout);
  }

  Future<void> toggleRsvp(Event event) async {
    final going = !isGoing(event);

    if (going) {
      _rsvpIds.add(event.id);
    } else {
      _rsvpIds.remove(event.id);
    }
    notifyListeners();
    await _prefs.setRsvpIds(_rsvpIds);

    try {
      await _service.setRsvp(event.id, userId, going).timeout(_writeTimeout);
    } catch (_) {
      if (going) {
        _rsvpIds.remove(event.id);
      } else {
        _rsvpIds.add(event.id);
      }
      notifyListeners();
      await _prefs.setRsvpIds(_rsvpIds);
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}