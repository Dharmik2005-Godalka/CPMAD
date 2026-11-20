import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service = EventService();
  StreamSubscription<List<Event>>? _subscription;

  List<Event> _events = [];
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
  bool isGoing(Event event) => event.isAttending(userId);

  // Derived state...
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

    _subscription = _service.getEvents().listen(
      (data) {
        _events = data;
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

  Future<void> toggleRsvp(Event event) {
    final going = !event.isAttending(userId);
    return _service.setRsvp(event.id, userId, going).timeout(_writeTimeout);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
