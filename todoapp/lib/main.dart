import 'package:flutter/material.dart';
import 'package:todoapp/screens/todo_screen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:TodoScreen(),
      title: 'TodoApp',
    );
  }
}
