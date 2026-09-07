import 'faculty.dart';

class Department {
  String name;
  List<Faculty> faculty;
  List<String> courses;
  List<String> facilities;
  String email;
  String phone;
  String location;

  Department({
    required this.name,
    required this.faculty,
    required this.courses,
    required this.facilities,
    required this.email,
    required this.phone,
    required this.location,
  });
}