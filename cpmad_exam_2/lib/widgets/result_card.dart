import 'package:flutter/material.dart';

/// Small result box: a grey title above a bold value.
class ResultCard extends StatelessWidget {
  // FIX1: value must is required
  const ResultCard({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      // FIX2: padding need this thing EdgeInsets
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      // FIX3: Colum spelling must is Column
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(
            value,
            // FIX4: missing comma
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
