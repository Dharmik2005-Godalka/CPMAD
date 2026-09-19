import 'package:flutter/material.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(const RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  const RegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Registration',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const RegistrationScreen(),
    );
  }
}