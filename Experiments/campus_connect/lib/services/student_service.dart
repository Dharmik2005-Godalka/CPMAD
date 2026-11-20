import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class StudentService 
{
  CollectionReference<Map<String, dynamic>> get _students =>
      FirebaseFirestore.instance.collection('students');

  // READ
  Stream<List<Student>> getStudents() 
  {
    return _students.orderBy('name').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Student.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // CREATE
  Future<void> addStudent(Student student) async 
  {
    await _students.add(student.toMap());
  }

  // UPDATE
  Future<void> updateStudent(Student student) async 
  {
    await _students.doc(student.id).update(student.toMap());
  }

  // DELETE
  Future<void> deleteStudent(String id) async 
  {
    await _students.doc(id).delete();
  }
}
