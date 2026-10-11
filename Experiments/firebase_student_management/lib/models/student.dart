import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String? id;
  final String name;
  final String rollNumber;
  final String department;
  final int semester;

  Student({
    this.id,
    required this.name,
    required this.rollNumber,
    required this.department,
    required this.semester,
  });

  // nameLower is stored so the search is not case sensitive
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nameLower': name.toLowerCase(),
      'rollNumber': rollNumber,
      'department': department,
      'semester': semester,
    };
  }

  factory Student.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      department: data['department'] ?? '',
      semester: data['semester'] ?? 1,
    );
  }
}
