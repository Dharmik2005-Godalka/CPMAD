import 'package:flutter/material.dart';

class Recipe 
{
  final String name;
  final String category;
  final String time;
  final String rating;
  final Color color;
  final IconData icon;

  Recipe({
    required this.name,
    required this.category,
    required this.time,
    required this.rating,
    required this.color,
    required this.icon,
  });
}
