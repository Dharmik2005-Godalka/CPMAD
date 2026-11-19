import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

class CommentService 
{
  final CollectionReference _comments = FirebaseFirestore.instance
      .collection('posts')
      .doc('post1')
      .collection('comments');

  // READ: 
  Stream<List<Comment>> getComments() 
  {
    return _comments
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Comment.fromDoc(doc)).toList());
  }

  // CREATE
  Future<void> addComment(String name, String text) 
  {
    return _comments.add({
      'name': name,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
