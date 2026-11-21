import '../database_helper.dart';
import '../models/note_model.dart';

class NoteController 
{
  final DatabaseHelper _database = DatabaseHelper.instance;

  Future<List<Note>> getNotes() 
  {
    return _database.getNotes();
  }

  Future<void> addNote(String title, String content) async 
  {
    final note = Note(
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    await _database.insertNote(note);
  }

  Future<void> updateNote(Note note) async 
  {
    await _database.updateNote(note);
  }

  Future<void> deleteNote(int id) async 
  {
    await _database.deleteNote(id);
  }
}
