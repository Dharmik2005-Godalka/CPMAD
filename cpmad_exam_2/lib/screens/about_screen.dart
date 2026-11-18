import 'package:flutter/material.dart';

/// Simple "About" page opened from the drawer.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('SplitEase v1.0')),
    );
  }
}
