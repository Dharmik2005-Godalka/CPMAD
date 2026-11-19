import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';

class WishlistScreen extends StatelessWidget 
{
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final wishlist = context.watch<WishlistProvider>();
    final items = wishlist.items;

    return Scaffold(
      appBar: AppBar(title: Text('Wishlist (${wishlist.count})')),
      body: items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Your wishlist is empty'),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.62,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) 
              {
                return ProductCard(product: items[index]);
              },
            ),
    );
  }
}
