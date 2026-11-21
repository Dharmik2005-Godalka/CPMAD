import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/quote_screen.dart';

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuotesScreen(),
    );
  }
}
