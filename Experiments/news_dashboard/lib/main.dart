import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

class AppScrollBehavior extends MaterialScrollBehavior 
{
  @override
  Set<PointerDeviceKind> get dragDevices => 
      {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: 'News Dashboard',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardScreen(),
    );
  }
}
