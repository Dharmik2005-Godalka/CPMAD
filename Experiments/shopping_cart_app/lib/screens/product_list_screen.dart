import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../utils/format.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import '../providers/wishlist_provider.dart';
import 'wishlist_screen.dart';

class ProductListScreen extends StatelessWidget 
{
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: 
        [  
          Consumer<WishlistProvider>(
            builder: (context, wishlist, _) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: wishlist.count > 0,
                  label: Text('${wishlist.count}'),
                  child: const Icon(Icons.favorite_border),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WishlistScreen()),
                  );
                },
              );
            },
          ),
          
          Consumer<CartProvider>(
            builder: (context, cart, _) 
            {
              return IconButton(
                icon: Badge(
                  isLabelVisible: cart.totalQuantity > 0,
                  label: Text('${cart.totalQuantity}'),
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: buildBody(context, provider),
    );
  }

  Widget buildBody(BuildContext context, ProductProvider provider) {
    // 1. Loading state
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error state
    if (provider.error != null) {
      return buildError(context, provider.error!);
    }

    // 3. Loaded state
    return buildLoaded(provider);
  }

  Widget buildError(BuildContext context, String message) 
  {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<ProductProvider>().fetchProducts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoaded(ProductProvider provider) {
    final products = provider.filteredProducts;

    return Column(
      children: [
        // Search box
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: provider.setSearchQuery,
          ),
        ),
        buildCategories(provider),
        
        Expanded(
          child: products.isEmpty
              ? const Center(child: Text('No products found'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) 
                  {
                    return ProductCard(product: products[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget buildCategories(ProductProvider provider) 
  {
    final categories = provider.categories;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) 
        {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ChoiceChip(
              label: Text(formatCategory(category)),
              selected: provider.selectedCategory == category,
              onSelected: (_) => provider.setCategory(category),
            ),
          );
        },
      ),
    );
  }
}
