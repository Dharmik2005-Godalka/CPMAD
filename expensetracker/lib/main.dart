import 'package:flutter/material.dart';

void main() {
  runApp(const expensetracker());
}

class expensetracker extends StatelessWidget {
  const expensetracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
        ),
        body: const Center(
          child: Text('Welcome to Expense Tracker!'),
        ),
      )
    );
  }
}
