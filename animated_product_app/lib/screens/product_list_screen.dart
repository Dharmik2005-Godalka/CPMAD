import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/favorite_button.dart';
import 'product_details_screen.dart';

class ProductListScreen extends StatefulWidget 
{
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> 
{
  void openDetails(Product product) 
  {
    Navigator.push(
      context,
      PageRouteBuilder
      (
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailsScreen(product: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    ).then((_) 
    {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalogue'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
        ),

        itemBuilder: (context, index) 
        {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => openDetails(product),
            onFavorite: () {
              setState(() {
                product.isFavorite = !product.isFavorite;
              });
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget 
{
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> 
{
  bool pressed = false;

  @override
  Widget build(BuildContext context) 
  {
    final product = widget.product;

    return GestureDetector(
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () => setState(() => pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(pressed ? 14 : 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: 
          [
            BoxShadow(
              color: Colors.black26,
              blurRadius: pressed ? 2 : 10,
              offset: Offset(0, pressed ? 1 : 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // hero animation
            Expanded(
              child: Hero(
                tag: 'product-${product.id}',
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: product.color.shade100,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Icon(
                    product.icon,
                    size: 64,
                    color: product.color.shade700,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 2),
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.indigo),
                        ),
                      ],
                    ),
                  ),
                  FavoriteButton(
                    isFavorite: product.isFavorite,
                    onTap: widget.onFavorite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}