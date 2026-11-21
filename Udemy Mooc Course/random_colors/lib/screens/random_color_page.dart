import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorPage extends StatefulWidget 
{
  const RandomColorPage({super.key});

  @override
  State<RandomColorPage> createState() => _RandomColorPageState();
}

class _RandomColorPageState extends State<RandomColorPage> 
{
  Color _containerColor = Colors.blue;
  Color _textColor = Colors.white;  
  Color _fabColor = Colors.blue;

  Color _getRandomColor() 
  {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
  }

  Color _getContrastColor(Color backgroundColor) 
  {
    double luminance =
        (0.299 * backgroundColor.red +
            0.587 * backgroundColor.green +
            0.114 * backgroundColor.blue) /
        255;

    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _changeColors() 
  {
    setState(() {
      _containerColor = _getRandomColor();
      _textColor = _getContrastColor(_containerColor);
      _fabColor = Color.fromRGBO(
        255 - _containerColor.red,
        255 - _containerColor.green,
        255 - _containerColor.blue,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: _containerColor,
          child: Center(
            child: Text(
              'Tap the button to change colors!',
              style: TextStyle(color: _textColor, fontSize: 20),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _fabColor,
          foregroundColor: _getContrastColor(_fabColor),
          onPressed: _changeColors,
          child: const Icon(Icons.color_lens),
        ),
      ),
    );
  }
}
