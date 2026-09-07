import 'package:flutter/material.dart';
import 'screens/department_screen.dart';

void main() {
  runApp(const DepartmentApp());
}

class DepartmentApp extends StatelessWidget {
  const DepartmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Department Info',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFEFEFEF),
      ),
      home: const DepartmentScreen(),
    );
  }
}