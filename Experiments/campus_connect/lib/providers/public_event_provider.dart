import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../services/public_event_service.dart';

class PublicEventProvider extends ChangeNotifier {
  final PublicEventService _service = PublicEventService();

  List<Event> _events = [];
  bool _isLoading = true;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    try {
      _events = await _service.fetchEvents();
      _error = null;
    } on TimeoutException {
      _error = 'The request timed out. Check your connection and try again.';
    } on http.ClientException {
      _error = 'Could not reach the server. Check your internet connection.';
    } catch (_) {
      _error = 'Could not load public events. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void retry() {
    _isLoading = true;
    _error = null;
    notifyListeners();
    load();
  }
}
