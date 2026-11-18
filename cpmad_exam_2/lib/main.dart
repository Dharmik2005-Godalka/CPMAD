import 'package:flutter/material.dart';

import 'screens/split_home.dart';
// >>> Q6RI START
import 'screens/about_screen.dart';
// <<< Q6RI END

void main() {
  runApp(const SplitEaseApp());
}

/// Root widget: theme and routes of SplitEase.
class SplitEaseApp extends StatelessWidget {
  const SplitEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplitEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const SplitHome(),
      // >>> Q6R START
      routes: {
        '/about': (context) => const AboutScreen(),
      },
      // <<< Q6R END
    );
  }
}
