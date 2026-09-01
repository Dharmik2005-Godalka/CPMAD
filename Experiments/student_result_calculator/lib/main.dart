import 'package:flutter/material.dart';
import 'package:student_result_calculator/screens/marks_input_screen.dart';

void main() {
  runApp(const ResultApp());
}

class ResultApp extends StatelessWidget {
  const ResultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Result Calculator',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MarksInputScreen(),
    );
  }
}