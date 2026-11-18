import 'dart:math';
import 'package:flutter/material.dart';

// Custom loader 2.
class BouncingDots extends StatefulWidget {
  final Color color;

  const BouncingDots({super.key, this.color = Colors.blue});

  @override
  State<BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with SingleTickerProviderStateMixin 
    {
  late AnimationController controller;

  @override
  void initState() 
  {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() 
  {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) 
          {
            final t = (controller.value + i * 0.2) % 1;
            final jump = -14 * sin(pi * t);

            return Transform.translate(
              offset: Offset(0, jump),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
