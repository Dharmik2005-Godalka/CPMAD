import 'package:flutter/material.dart';
import 'screens/video_feed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Feed',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: const VideoFeedScreen(),
    );
  }
}
