import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/profile_product_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Widget countCard(String label, int count) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$count', style: const TextStyle(fontSize: 24)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = products.where((p) => p.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      drawer: const AppDrawer(currentRoute: '/profile'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 45,
              child: Icon(Icons.person, size: 50),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Shopping App User',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              countCard('Cart Items', cartItems.length),
              countCard('Favorites', favorites.length),
            ],
          ),

          sectionTitle('Carted Products'),
          if (cartItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Your cart is empty.'),
            ),
          ...cartItems.map(
            (product) => ProfileProductCard(
              product: product,
              onDelete: () {
                setState(() {
                  cartItems.remove(product);
                });
              },
            ),
          ),

          sectionTitle('Favorite Products'),
          if (favorites.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No favorites yet.'),
            ),
          ...favorites.map(
            (product) => ProfileProductCard(
              product: product,
              onDelete: () {
                setState(() {
                  product.isFavorite = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}