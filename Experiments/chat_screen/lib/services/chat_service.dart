import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatService 
{
  final CollectionReference _messages =
      FirebaseFirestore.instance.collection('messages');

  // READ: 
  Stream<List<Message>> getMessages() 
  {
    return _messages
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromDoc(doc)).toList());
  }

  // CREATE
  Future<void> sendMessage(String text, String sender) 
  {
    return _messages.add({
      'text': text,
      'sender': sender,
      'createdAt': FieldValue.serverTimestamp(),
      'edited': false,
    });
  }

  // UPDATE
  Future<void> editMessage(String id, String newText) 
  {
    return _messages.doc(id).update({
      'text': newText,
      'edited': true,
    });
  }

  // DELETE
  Future<void> deleteMessage(String id) 
  {
    return _messages.doc(id).delete();
  }
}
