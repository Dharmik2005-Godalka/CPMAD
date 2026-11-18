import 'package:flutter/material.dart';

/// Lists the saved splits (newest first).
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.history, required this.onClear});

  final List<String> history;
  final Future<void> Function() onClear;

  @override
  Widget build(BuildContext context) {
    // >>> Q7A3 START
    return const Center(child: Text('TODO (Q7-A): show the saved splits'));
    // <<< Q7A3 END
  }
}
