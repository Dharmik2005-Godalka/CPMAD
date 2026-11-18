import 'package:flutter/material.dart';

/// Preference screen; returns the chosen values when "Save settings" is tapped.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _gst = false;
  bool _roundUp = false;

  @override
  Widget build(BuildContext context) {
    // >>> Q6B3 START
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('TODO (Q6-B): settings form')),
    );
    // <<< Q6B3 END
  }
}
