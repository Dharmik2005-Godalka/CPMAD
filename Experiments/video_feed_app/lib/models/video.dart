import 'package:flutter/material.dart';

class Video {
  final String title;
  final String channel;
  final String views;
  final String duration;
  final Color color;

  Video({
    required this.title,
    required this.channel,
    required this.views,
    required this.duration,
    required this.color,
  });
}
