import 'package:flutter/material.dart';

import 'widgets/result_card.dart';

/// Preview for Q2.  Run with:  flutter run -t lib/q2_preview.dart
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ResultCard(title: 'Per person', value: '₹550.00'),
        ),
      ),
    ),
  );
}
