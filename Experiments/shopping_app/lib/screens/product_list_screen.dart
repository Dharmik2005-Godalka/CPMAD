import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  void openDetails(Product product) {
    Navigator.pushNamed(context, '/details', arguments: product)
        .then((_) => setState(() {}));
  }

  void toggleFavorite(Product product) {
    setState(() {
      product.isFavorite = !product.isFavorite;
    });
  }

  void addToCart(Product product) {
    cartItems.add(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          bottom: TabBar(
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        drawer: const AppDrawer(currentRoute: '/products'),
        bottomNavigationBar: const AppBottomNav(currentIndex: 1),
        body: TabBarView(
          children: categories.map((category) {
            final list = products.where((p) => p.category == category).toList();
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final product = list[index];
                return ProductCard(
                  product: product,
                  onTap: () => openDetails(product),
                  onDoubleTap: () => toggleFavorite(product),
                  onLongPress: () => addToCart(product),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}