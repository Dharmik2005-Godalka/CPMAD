import 'package:flutter/material.dart';

class AppTheme 
{
  static const List<Color> seedColors = [
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
    Colors.pink,
    Colors.green,
  ];

  static ThemeData build(Color seed, Brightness brightness) 
  {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seed,
      brightness: brightness,
    );
  }
}
