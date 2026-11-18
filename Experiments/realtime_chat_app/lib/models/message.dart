import 'package:cloud_firestore/cloud_firestore.dart';

class Message 
{
  final String id;
  final String text;
  final String sender;
  final DateTime? time;
  final bool edited;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
    required this.edited,
  });

  factory Message.fromDoc(DocumentSnapshot doc) 
  {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['createdAt'] as Timestamp?;

    return Message(
      id: doc.id,
      text: data['text'] ?? '',
      sender: data['sender'] ?? 'Unknown',
      time: timestamp?.toDate(),
      edited: data['edited'] ?? false,
    );
  }
}
