import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';
import '../widgets/cart_item_tile.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cart.totalQuantity})'),
        actions: [
          if (!cart.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear cart',
              onPressed: cart.clear,
            ),
        ],
      ),
      body: cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Your cart is empty'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return CartItemTile(item: cart.items[index]);
                    },
                  ),
                ),
                buildSummary(context, cart),
              ],
            ),
    );
  }

    Widget buildSummary(BuildContext context, CartProvider cart) {
    final taxPercent = (CartProvider.taxRate * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border(top: BorderSide(color: Colors.green.shade100)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildRow('Items', '${cart.totalQuantity}'),
            buildRow('Subtotal', formatPrice(cart.subtotal)),
            buildRow('Tax ($taxPercent%)', formatPrice(cart.tax)),
            const Divider(),
            buildRow('Total', formatPrice(cart.total), bold: true),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CheckoutScreen(),
                    ),
                  );
                },
                child: const Text('Proceed to checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
