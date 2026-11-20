class Student 
{
  final String id;
  final String name;
  final String rollNo;
  final String department;
  final int year;
  final String email;
  final String phone;
  final String? photo; 

  const Student({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.department,
    required this.year,
    required this.email,
    required this.phone,
    this.photo,
  });

  factory Student.fromMap(String id, Map<String, dynamic> map) 
  {
    return Student(
      id: id,
      name: map['name'] ?? '',
      rollNo: map['rollNo'] ?? '',
      department: map['department'] ?? '',
      year: (map['year'] as num?)?.toInt() ?? 1,
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photo: map['photo'] as String?,
    );
  }

  Map<String, dynamic> toMap() 
  {
    return {
      'name': name,
      'rollNo': rollNo,
      'department': department,
      'year': year,
      'email': email,
      'phone': phone,
      'photo': photo,
    };
  }
}
