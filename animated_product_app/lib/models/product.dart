import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final IconData icon;
  final MaterialColor color;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.icon,
    required this.color,
    this.isFavorite = false,
  });
}

final List<Product> products = [
  Product(
    id: 1,
    name: 'Headphones',
    category: 'Electronics',
    price: 2999,
    description: 'Wireless over-ear headphones with deep bass and 30 hours of battery life.',
    icon: Icons.headphones,
    color: Colors.blue,
  ),
  Product(
    id: 2,
    name: 'Smart Watch',
    category: 'Electronics',
    price: 4499,
    description: 'Fitness tracker with heart rate monitor, sleep tracking and notifications.',
    icon: Icons.watch,
    color: Colors.purple,
  ),
  Product(
    id: 3,
    name: 'Camera',
    category: 'Electronics',
    price: 15999,
    description: 'Compact digital camera with 24 MP sensor and full HD video recording.',
    icon: Icons.camera_alt,
    color: Colors.lightBlue,
  ),
  Product(
    id: 4,
    name: 'Running Shoes',
    category: 'Fashion',
    price: 1999,
    description: 'Lightweight and breathable running shoes with a comfortable cushioned sole.',
    icon: Icons.directions_run,
    color: Colors.orange,
  ),
  Product(
    id: 5,
    name: 'Laptop',
    category: 'Electronics',
    price: 45999,
    description: '15 inch laptop with fast SSD storage, perfect for study and coding.',
    icon: Icons.laptop,
    color: Colors.indigo,
  ),
  Product(
    id: 6,
    name: 'Game Controller',
    category: 'Gaming',
    price: 1799,
    description: 'Ergonomic wireless controller with responsive buttons and vibration feedback.',
    icon: Icons.sports_esports,
    color: Colors.red,
  ),
];
