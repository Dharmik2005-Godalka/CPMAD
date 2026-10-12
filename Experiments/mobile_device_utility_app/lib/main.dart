import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/image_screen.dart';
import 'screens/sensor_screen.dart';
import 'screens/location_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Utility',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/image': (context) => const ImageScreen(),
        '/sensor': (context) => const SensorScreen(),
        '/location': (context) => const LocationScreen(),
      },
    );
  }
}
