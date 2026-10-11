import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class StudentService {
  final CollectionReference<Map<String, dynamic>> _students =
      FirebaseFirestore.instance.collection('students');

  // Create
  Future<void> addStudent(Student student) async {
    await _students.add(student.toMap());
  }

  // Update
  Future<void> updateStudent(Student student) async {
    await _students.doc(student.id).update(student.toMap());
  }

  // Delete
  Future<void> deleteStudent(String id) async {
    await _students.doc(id).delete();
  }

  // Read + Search (names starting with the search text)
  Stream<List<Student>> getStudents(String search) {
    final text = search.trim().toLowerCase();

    Query<Map<String, dynamic>> query;
    if (text.isEmpty) {
      query = _students.orderBy('nameLower');
    } else {
      query = _students
          .where('nameLower', isGreaterThanOrEqualTo: text)
          .where('nameLower', isLessThan: '$text\uf8ff');
    }

    return query.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Student.fromDoc(doc)).toList(),
        );
  }
}
