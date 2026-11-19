import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';
import 'product_image.dart';
import '../providers/wishlist_provider.dart';

class ProductCard extends StatelessWidget 
{
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) 
  {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(url: product.thumbnail),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, _) {
                      final liked = wishlist.isWishlisted(product);
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () => wishlist.toggle(product),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatCategory(product.category),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  formatPrice(product.price),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: buildCartControls(),
          ),
        ],
      ),
    );
  }

  Widget buildCartControls() 
  {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final qty = cart.quantityOf(product);

        if (qty == 0) 
        {
          return SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: () => cart.addProduct(product),
              child: const Text('Add to cart'),
            ),
          );
        }

        return SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                visualDensity: VisualDensity.compact,
                onPressed: () => cart.decreaseQuantity(product),
              ),

              Text
              (
                '$qty',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton
              (
                icon: const Icon(Icons.add_circle_outline),
                visualDensity: VisualDensity.compact,
                onPressed: () => cart.addProduct(product),
              ),
            ],
          ),
        );
      },
    );
  }
}
