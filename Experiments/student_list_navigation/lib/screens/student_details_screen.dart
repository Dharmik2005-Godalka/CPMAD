import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = ModalRoute.of(context)!.settings.arguments as Student;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 50,
              child: Text(
                student.name[0],
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              student.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.numbers),
                    title: const Text('Roll Number'),
                    subtitle: Text('${student.rollNumber}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.apartment),
                    title: const Text('Department'),
                    subtitle: Text(student.department),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Semester'),
                    subtitle: Text('${student.semester}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(student.email),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}