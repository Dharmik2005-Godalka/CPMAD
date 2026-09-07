import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Developer Portfolio',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFEFEFEF),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
      home: const ProfileScreen(),
    );
  }
}