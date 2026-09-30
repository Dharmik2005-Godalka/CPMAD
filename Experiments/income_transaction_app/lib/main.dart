import 'package:flutter/material.dart';
import 'package:income_transaction_app/screens/transaction_screen.dart';

void main() {
  runApp(const TransactionApp());
}

class TransactionApp extends StatelessWidget {
  const TransactionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TransactionScreen(),
      title: 'Income & Transactions',
    );
  }
}
