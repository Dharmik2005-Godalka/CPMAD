import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget 
{
  final String url;

  const ProductImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) 
  {
    return Container(
      color: Colors.grey.shade100,
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) 
        {
          return const Center(
            child: Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
      ),
    );
  }
}
