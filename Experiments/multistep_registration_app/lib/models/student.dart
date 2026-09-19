class Student {
  String name;
  String email;
  String phone;
  String password;
  double age;
  String tenthPercentage;
  String tenthSchool;
  String twelfthPercentage;
  String twelfthSchool;
  String appliedCourse;
  List<String> skills;
  bool wantsNotifications;
  bool confirmedInfo;

  Student({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.age,
    this.tenthPercentage = '',
    this.tenthSchool = '',
    this.twelfthPercentage = '',
    this.twelfthSchool = '',
    this.appliedCourse = '',
    this.skills = const [],
    this.wantsNotifications = false,
    this.confirmedInfo = false,
  });
}