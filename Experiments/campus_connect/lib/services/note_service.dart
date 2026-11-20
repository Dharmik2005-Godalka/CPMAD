import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteService 
{
  CollectionReference<Map<String, dynamic>> _notes(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notes');

  Stream<List<Note>> getNotes(String uid) 
  {
    return _notes(uid).orderBy('updatedAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Note.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<String> addNote(String uid, Note note) async 
  {
    final ref = await _notes(uid).add(note.toMap());
    return ref.id;
  }

  Future<void> updateNote(String uid, Note note) async 
  {
    await _notes(uid).doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String uid, String id) async 
  {
    await _notes(uid).doc(id).delete();
  }
}
