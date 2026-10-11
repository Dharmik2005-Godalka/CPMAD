import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openDetails(Product product) {
    Navigator.pushNamed(context, '/details', arguments: product)
        .then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final featured = products.take(4).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const AppDrawer(currentRoute: '/'),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/products'),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Big Sale!\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Featured Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...featured.map(
            (product) => ProductCard(
              product: product,
              onTap: () => openDetails(product),
            ),
          ),
        ],
      ),
    );
  }
}