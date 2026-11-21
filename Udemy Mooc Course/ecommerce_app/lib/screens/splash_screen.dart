import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget 
{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
{
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () 
    {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.flutter_dash, size: 70, color: Colors.white),
            SizedBox(height: 20),
            Text('My App', style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
