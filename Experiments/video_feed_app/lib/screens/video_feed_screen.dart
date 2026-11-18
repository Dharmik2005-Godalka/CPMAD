import 'package:flutter/material.dart';
import '../models/video.dart';

class VideoFeedScreen extends StatelessWidget {
  const VideoFeedScreen({super.key});

  final List<String> categories = const [
    'All',
    'Music',
    'Gaming',
    'News',
    'Sports',
    'Movies',
    'Learning',
  ];

  List<Video> get videos => [
        Video(
          title: 'Flutter Tutorial for Beginners',
          channel: 'Code Academy',
          views: '1.2M views',
          duration: '12:45',
          color: Colors.blue,
        ),
        Video(
          title: 'Top 10 Songs of the Year',
          channel: 'Music Hub',
          views: '3.4M views',
          duration: '08:20',
          color: Colors.purple,
        ),
        Video(
          title: 'Best Gaming Moments 2026',
          channel: 'Game Zone',
          views: '850K views',
          duration: '15:10',
          color: Colors.green,
        ),
        Video(
          title: 'Cricket Match Highlights',
          channel: 'Sports Live',
          views: '2.1M views',
          duration: '10:05',
          color: Colors.orange,
        ),
        Video(
          title: 'Daily News Summary',
          channel: 'News Today',
          views: '500K views',
          duration: '05:30',
          color: Colors.lightBlue,
        ),
        Video(
          title: 'Learn Dart in 30 Minutes',
          channel: 'Code Academy',
          views: '980K views',
          duration: '30:00',
          color: Colors.indigo,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final list = videos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Feed'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: list.length + 1,
          itemBuilder: (context, index) {
            // First item = categories + featured section
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildCategories(),
                  buildFeatured(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }
            return buildVideoTile(list[index - 1]);
          },
        ),
      ),
    );
  }

  // Horizontal category chips
  Widget buildCategories() {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Chip(label: Text(categories[index])),
          );
        },
      ),
    );
  }

  // Featured video card
  Widget buildFeatured() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.play_circle_fill, size: 70, color: Colors.white),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const Positioned(
            bottom: 10,
            left: 12,
            child: Text(
              'Live: Flutter Conference 2026',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // One video row
  Widget buildVideoTile(Video video) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 140,
            height: 80,
            decoration: BoxDecoration(
              color: video.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 36),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.black87,
                    child: Text(
                      video.duration,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  video.channel,
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  video.views,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
