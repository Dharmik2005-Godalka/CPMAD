import 'package:flutter/material.dart';

class CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final int count;

  const CategoryHeaderDelegate({required this.title, required this.count});

  @override
  double get minExtent => 44;

  @override
  double get maxExtent => 44;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) 
  {
    // Solid color, so the list scrolls under the pinned header
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text('$count', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CategoryHeaderDelegate oldDelegate) 
  {
    return oldDelegate.title != title || oldDelegate.count != count;
  }
}
