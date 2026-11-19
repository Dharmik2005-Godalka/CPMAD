import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';
import 'product_image.dart';

class CartItemTile extends StatelessWidget 
{
  final CartItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) 
  {
    final cart = context.read<CartProvider>();
    final product = item.product;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ProductImage(url: product.thumbnail),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatPrice(product.price)} each',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    children: 
                    [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => cart.decreaseQuantity(product),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => cart.addProduct(product),
                      ),
                    ],
                  ),
                ],
              ),
            ),

                       Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => cart.removeProduct(product),
                ),
                Text(
                  formatPrice(item.subtotal),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
