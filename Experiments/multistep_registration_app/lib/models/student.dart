class Student {
  String name;
  String email;
  String phone;
  String gender;
  List<String> courses;
  double age;
  bool wantsUpdates;

  Student({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.courses,
    required this.age,
    required this.wantsUpdates,
  });
}
