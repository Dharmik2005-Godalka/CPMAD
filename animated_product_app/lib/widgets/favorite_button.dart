import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget 
{
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton
  ({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) 
  {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFavorite ? Colors.red.shade50 : Colors.grey.shade200,
        ),

        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.elasticOut,
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isFavorite),
            color: isFavorite ? Colors.red : Colors.grey,
            size: 24,
          ),
        ),
      ),
    );
  }
}
