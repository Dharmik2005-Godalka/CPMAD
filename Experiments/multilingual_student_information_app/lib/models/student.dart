class Student {
  final int rollNumber;
  final String name;
  final String departmentKey;
  final DateTime admissionDate;
  final double fees;
  final double percentage;

  Student({
    required this.rollNumber,
    required this.name,
    required this.departmentKey,
    required this.admissionDate,
    required this.fees,
    required this.percentage,
  });
}

final List<Student> students = [
  Student(
    rollNumber: 101,
    name: 'Dharmik Godalka',
    departmentKey: 'dept_computer',
    admissionDate: DateTime(2024, 6, 15),
    fees: 125000,
    percentage: 85.5,
  ),
  Student(
    rollNumber: 102,
    name: 'Jeet Vasoya',
    departmentKey: 'dept_it',
    admissionDate: DateTime(2024, 6, 20),
    fees: 118500,
    percentage: 91.25,
  ),
  Student(
    rollNumber: 103,
    name: 'Ram Mehta',
    departmentKey: 'dept_mech',
    admissionDate: DateTime(2022, 7, 5),
    fees: 98000,
    percentage: 72.8,
  ),
  Student(
    rollNumber: 104,
    name: 'Prem Joshi',
    departmentKey: 'dept_electronics',
    admissionDate: DateTime(2024, 7, 1),
    fees: 110000,
    percentage: 88.4,
  ),
];