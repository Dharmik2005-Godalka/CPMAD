import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteStorage {
  static const _fileName = 'notes.json';
  static const _webKey = 'notes_json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<Note>> loadNotes() async {
    try {
      String? text;

      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        text = prefs.getString(_webKey);
      } else {
        final file = await _file();
        if (await file.exists()) {
          text = await file.readAsString();
        }
      }

      if (text == null || text.isEmpty) return [];

      final list = jsonDecode(text) as List<dynamic>;
      return list.map((item) {
        final map = item as Map<String, dynamic>;
        return Note.fromMap(map['id'] ?? '', map);
      }).toList();
    } catch (_) {
      return []; 
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    try {
      final text = jsonEncode(
        notes.map((n) => {'id': n.id, ...n.toMap()}).toList(),
      );

      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_webKey, text);
      } else {
        final file = await _file();
        await file.writeAsString(text);
      }
    } catch (_) {
    }
  }

  Future<void> clear() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_webKey);
      } else {
        final file = await _file();
        if (await file.exists()) await file.delete();
      }
    } catch (_) {
      // nothing to delete
    }
  }
}
