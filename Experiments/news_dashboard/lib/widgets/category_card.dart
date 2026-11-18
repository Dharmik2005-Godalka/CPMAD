import 'package:flutter/material.dart';
import '../models/article.dart';

class CategoryCard extends StatelessWidget 
{
  final NewsCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) 
  {
    return Card(
      elevation: 2,
      color: category.color.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            [
              Icon(category.icon, size: 34, color: category.color.shade700),
              const SizedBox(height: 6),
              Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: category.color.shade900,
                ),
              ),
              Text(
                '${category.count} articles',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
