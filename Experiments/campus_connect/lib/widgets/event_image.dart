import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/event.dart';

class EventImage extends StatelessWidget {
  final Event event;
  final double height;

  const EventImage({super.key, required this.event, required this.height});

  static const Map<String, MaterialColor> _colors = {
    'Tech': Colors.indigo,
    'Academic': Colors.green,
    'Cultural': Colors.pink,
    'Sports': Colors.orange,
  };

  static const Map<String, IconData> _icons = {
    'Tech': Icons.computer,
    'Academic': Icons.school,
    'Cultural': Icons.theater_comedy,
    'Sports': Icons.sports_cricket,
  };

  @override
  Widget build(BuildContext context) {
    final photo = event.image;

    if (photo != null && photo.isNotEmpty) {
      try {
        return Image.memory(
          base64Decode(photo),
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
        );
      } catch (_) {
      }
    }

    final base = _colors[event.category] ?? Colors.blueGrey;
    final icon = _icons[event.category] ?? Icons.event;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [base.shade300, base.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: height * 0.4),
      ),
    );
  }
}
