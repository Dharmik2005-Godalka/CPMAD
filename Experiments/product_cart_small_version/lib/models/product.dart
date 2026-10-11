import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final IconData icon;
  final Color color;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.icon,
    required this.color,
  });
}

final List<Product> products = [
  Product(
    id: 1,
    name: 'Laptop',
    price: 50000,
    description: 'A good screen Quality with high resolution. Containing 16GB RAM and 512GB SSD.',
    icon: Icons.laptop,
    color: Colors.blue,
  ),
  Product(
    id: 2,
    name: 'Camera',
    price: 10000,
    description: '10 MP digital camera with a zoom lens.',
    icon: Icons.camera_alt,
    color: Colors.purple,
  ),
  Product(
    id: 3,
    name: 'Speaker',
    price: 2000,
    description: 'Portable bluetooth speaker with 50 hours of playback.',
    icon: Icons.speaker,
    color: Colors.green,
  ),
  Product(
    id: 4,
    name: 'Gaming Console',
    price: 30000,
    description: 'High-performance gaming console with fast processing and great graphics.',
    icon: Icons.videogame_asset,
    color: Colors.red,
  ),
  Product(
    id: 5,
    name: 'Keyboard',
    price: 1500,
    description: 'Full size keyboard with quiet keys.',
    icon: Icons.keyboard,
    color: Colors.teal,
  ),
  Product(
    id: 6,
    name: 'I-Pad',
    price: 90000,
    description: '10 inch tablet with a sharp display.',
    icon: Icons.tablet_mac,
    color: Colors.orange,
  ),
];