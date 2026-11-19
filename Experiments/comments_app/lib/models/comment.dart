import 'package:cloud_firestore/cloud_firestore.dart';

class Comment 
{
  final String id;
  final String name;
  final String text;
  final DateTime? time;

  Comment({
    required this.id,
    required this.name,
    required this.text,
    required this.time,
  });

  factory Comment.fromDoc(DocumentSnapshot doc) 
  {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['createdAt'] as Timestamp?;

    return Comment
    (
      id: doc.id,
      name: data['name'] ?? 'Anonymous',
      text: data['text'] ?? '',
      time: timestamp?.toDate(),
    );
  }
}
