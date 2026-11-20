import 'package:campus_connect/models/student.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toMap and fromMap round trip keeps every field', () {
    const student = Student(
      id: '1',
      name: 'Asha Patel',
      rollNo: 'CE101',
      department: 'Computer',
      year: 2,
      email: 'asha@mail.com',
      phone: '9876543210',
    );

    final copy = Student.fromMap('1', student.toMap());

    expect(copy.id, '1');
    expect(copy.name, 'Asha Patel');
    expect(copy.rollNo, 'CE101');
    expect(copy.department, 'Computer');
    expect(copy.year, 2);
    expect(copy.email, 'asha@mail.com');
    expect(copy.phone, '9876543210');
    expect(copy.photo, isNull);
  });

  test('fromMap falls back to defaults for missing fields', () {
    final student = Student.fromMap('2', {});

    expect(student.name, '');
    expect(student.year, 1);
  });
}
