import 'package:flutter/material.dart';

void main() 
{
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('This is the my first application...')),
        body: Container(
          color: Colors.red,
          child: Center(
            child: Text(
              'First App',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}
