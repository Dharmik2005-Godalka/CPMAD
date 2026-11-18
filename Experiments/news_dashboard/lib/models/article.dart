import 'package:flutter/material.dart';

class Article {
  final int id;
  final String title;
  final String category;
  final String source;
  final String time;
  final IconData icon;
  final MaterialColor color;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.source,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class NewsCategory {
  final String name;
  final IconData icon;
  final MaterialColor color;
  final int count;

  NewsCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
  });
}

final Article featuredArticle = Article(
  id: 0,
  title: 'Global Tech Summit Unveils the Next Generation of AI Tools',
  category: 'Technology',
  source: 'Tech Daily',
  time: '1h ago',
  icon: Icons.memory,
  color: Colors.indigo,
);

final List<Article> sampleArticles = 
[
  Article
  (
    id: 1,
    title: 'Local Team Wins the National Football Championship',
    category: 'Sports',
    source: 'Sports Today',
    time: '2h ago',
    icon: Icons.sports_soccer,
    color: Colors.green,
  ),

  Article
  (
    id: 2,
    title: 'Stock Markets Close Higher After Strong Earnings Reports',
    category: 'Business',
    source: 'Market Watch',
    time: '3h ago',
    icon: Icons.trending_up,
    color: Colors.orange,
  ),

  Article(
    id: 3,
    title: 'New Study Shows Daily Walking Improves Heart Health',
    category: 'Health',
    source: 'Health Journal',
    time: '4h ago',
    icon: Icons.favorite,
    color: Colors.red,
  ),

  Article
  (
    id: 4,
    title: 'Scientists Discover Water Traces on a Distant Exoplanet',
    category: 'Science',
    source: 'Science Now',
    time: '5h ago',
    icon: Icons.science,
    color: Colors.purple,
  ),

  Article
  (
    id: 5,
    title: 'Highly Awaited Sci-Fi Movie Breaks Opening Weekend Records',
    category: 'Entertainment',
    source: 'Film Times',
    time: '6h ago',
    icon: Icons.movie,
    color: Colors.pink,
  ),

  Article
  (
    id: 6,
    title: 'Startups Raise Record Funding in the Mobile App Sector',
    category: 'Business',
    source: 'Startup Weekly',
    time: '7h ago',
    icon: Icons.phone_android,
    color: Colors.orange,
  ),

  Article
  (
    id: 7,
    title: 'Open-Source Framework Releases Major Performance Update',
    category: 'Technology',
    source: 'Dev News',
    time: '8h ago',
    icon: Icons.code,
    color: Colors.blue,
  ),
];

final List<NewsCategory> categories = 
[
  NewsCategory(name: 'Technology', icon: Icons.computer, color: Colors.blue, count: 24),
  NewsCategory(name: 'Sports', icon: Icons.sports_soccer, color: Colors.green, count: 18),
  NewsCategory(name: 'Business', icon: Icons.business_center, color: Colors.orange, count: 15),
  NewsCategory(name: 'Health', icon: Icons.health_and_safety, color: Colors.red, count: 12),
  NewsCategory(name: 'Science', icon: Icons.science, color: Colors.purple, count: 9),
  NewsCategory(name: 'Entertainment', icon: Icons.movie, color: Colors.pink, count: 21),
];
