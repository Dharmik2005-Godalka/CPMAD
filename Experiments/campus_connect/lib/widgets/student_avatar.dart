import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentAvatar extends StatelessWidget {
  final Student student;
  final double radius;

  const StudentAvatar({super.key, required this.student, this.radius = 24});

  @override
  Widget build(BuildContext context) 
  {
    ImageProvider? image;
    final photo = student.photo;
    if (photo != null && photo.isNotEmpty) 
    {
      try {
        image = MemoryImage(base64Decode(photo));
      } catch (_) {
        image = null; 
      }
    }

    final initial =
        student.name.isEmpty ? '?' : student.name[0].toUpperCase();

    return CircleAvatar(
      radius: radius,
      backgroundImage: image,
      child: image == null
          ? Text(initial, style: TextStyle(fontSize: radius * 0.8))
          : null,
    );
  }
}
