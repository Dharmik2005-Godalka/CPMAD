import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';

class NoteProvider extends ChangeNotifier {
  final NoteService _service = NoteService();
  StreamSubscription<List<Note>>? _subscription;

  List<Note> _notes = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  NoteFilter _filter = NoteFilter.all;

  static const Duration _writeTimeout = Duration(seconds: 15);

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  NoteFilter get filter => _filter;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  List<Note> get filteredNotes {
    final result = _notes
        .where((n) => _filter == NoteFilter.all || n.isPinned)
        .toList();

    result.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return result.search(_searchQuery);
  }

  void listen() {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;

    _subscription = _service.getNotes(_uid).listen(
      (data) {
        _notes = data;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (_) {
        _error = 'Could not load notes. Check your connection and try again.';
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
    _notes = [];
    _isLoading = true;
    _error = null;
    _searchQuery = '';
    _filter = NoteFilter.all;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(NoteFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<Note> save({
    Note? existing,
    required String title,
    required String content,
  }) async {
    final now = DateTime.now();

  if (existing == null) {
    final id = await _service
        .addNote(
          _uid,
          Note(id: '', title: title, content: content, createdAt: now, updatedAt: now),
        )
        .timeout(_writeTimeout);
    return Note(
      id: id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
  }

    final updated =
    existing.copyWith(title: title, content: content, updatedAt: now);
    await _service.updateNote(_uid, updated).timeout(_writeTimeout);
    return updated;
  }

  Future<void> togglePin(Note note) {
    return _service
        .updateNote(_uid, note.copyWith(isPinned: !note.isPinned))
        .timeout(_writeTimeout);
  }

  Future<void> deleteNote(String id) {
    _notes = _notes.where((n) => n.id != id).toList();
    notifyListeners();
    return _service.deleteNote(_uid, id).timeout(_writeTimeout);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
