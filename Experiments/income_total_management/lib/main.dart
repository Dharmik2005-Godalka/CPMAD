import 'package:flutter/material.dart';
import 'package:income_total_management/screens/expense_screen.dart';

void main() {
  runApp(const ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpenseScreen(),
      title: 'Expense Manager',
    );
  }
}