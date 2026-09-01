import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quotes_app/screens/quotes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuotesScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: Icon(Icons.flutter_dash,size:200)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Developed By:'),
          Text('The one and only Dharmik',
          style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      )
      
      ],)
    );
  }
}