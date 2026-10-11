class Student {
  final int rollNumber;
  final String name;
  final String department;
  final int semester;
  final String email;

  Student({
    required this.rollNumber,
    required this.name,
    required this.department,
    required this.semester,
    required this.email,
  });
}

final List<Student> students = [
  Student(
    rollNumber: 1,
    name: 'Dharmik Godalka',
    department: 'Information and Communication Technology',
    semester: 5,
    email: 'dharmik01@gmail.com',
  ),
  Student(
    rollNumber: 2,
    name: 'Jeet Vasoya',
    department: 'Computer Engineering',
    semester: 3,
    email: 'jeet@gmail.com',
  ),
  Student(
    rollNumber: 3,
    name: 'Aum Dave',
    department: 'Information and Communication Technology',
    semester: 5,
    email: 'aum@yahoo.com',
  ),
  Student(
    rollNumber: 4,
    name: 'Diva Parekh',
    department: 'Information Technology',
    semester: 5,
    email: 'diva@gmail.com',
  ),
  Student(
    rollNumber: 5,
    name: 'Prem Joshi',
    department: 'Electronics and Communication Engineering',
    semester: 1,
    email: 'prem@gmail.com',
  ),
];