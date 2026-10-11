import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final IconData icon;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.icon,
    this.isFavorite = false,
  });
}

final List<String> categories = ['Electronics', 'Fashion', 'Books'];

final List<Product> products = [
  Product(
    id: 1,
    name: 'Smart Phone',
    category: 'Electronics',
    price: 15000,
    description: 'Latest model with high-resolution display and fast processor and with good camera quality.',
    icon: Icons.smartphone,
  ),
  Product(
    id: 2,
    name: 'Headphones',
    category: 'Electronics',
    price: 2000,
    description: 'Wireless over-ear headphones with noise cancellation and good sound quality.',
    icon: Icons.headphones,
  ),
  Product(
    id: 3,
    name: 'Smart Watch',
    category: 'Electronics',
    price: 1500,
    description: 'Tracks steps, heart rate and notifications.',
    icon: Icons.watch,
  ),
  Product(
    id: 4,
    name: 'Casual Shirt',
    category: 'Fashion',
    price: 500,
    description: 'Comfortable cotton shirt for everyday wear.',
    icon: Icons.checkroom,
  ),
  Product(
    id: 5,
    name: 'Shoes',
    category: 'Fashion',
    price: 800,
    description: 'Lightweight shoes with good grip for running and walking.',
    icon: Icons.directions_run,
  ),
  Product(
    id: 6,
    name: 'Bag',
    category: 'Fashion',
    price: 2500,
    description: 'Spacious backpack with a laptop compartment.',
    icon: Icons.backpack,
  ),
  Product(
    id: 7,
    name: 'Flutter Book',
    category: 'Books',
    price: 100,
    description: 'Beginner friendly book to learn Flutter and Dart.',
    icon: Icons.menu_book,
  ),
  Product(
    id: 8,
    name: 'Notebook',
    category: 'Books',
    price: 600,
    description: 'Pack of 5 ruled notebooks for notes and assignments.',
    icon: Icons.book,
  ),
];

final List<Product> cartItems = [];