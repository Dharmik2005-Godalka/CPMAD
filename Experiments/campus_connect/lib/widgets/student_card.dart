import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/constants.dart';
import 'student_avatar.dart';

class StudentCard extends StatelessWidget 
{
  final Student student;
  final VoidCallback onTap;

  const StudentCard({super.key, required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) 
  {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: 'avatar-${student.id}',
          child: StudentAvatar(student: student, radius: 24),
        ),
        title: Text(
          student.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${student.rollNo}  •  ${student.department}  •  ${yearLabel(student.year)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
