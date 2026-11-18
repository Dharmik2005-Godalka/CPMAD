import 'dart:math';
import 'package:flutter/material.dart';

// Custom loader 1: 
class SpinningLoader extends StatefulWidget 
{
  final double size;
  final Color color;

  const SpinningLoader({
    super.key,
    this.size = 60,
    this.color = Colors.indigo,
  });

  @override
  State<SpinningLoader> createState() => _SpinningLoaderState();
}

class _SpinningLoaderState extends State<SpinningLoader>
    with SingleTickerProviderStateMixin 
    {
  late AnimationController controller;

  @override
  void initState() 
  {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
    return RotationTransition(
      turns: controller,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _ArcPainter(widget.color),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter 
{
  final Color color;
  _ArcPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) 
  {
    final rect = Rect.fromLTWH(3, 3, size.width - 6, size.height - 6);

    // faint full circle 
    final trackPaint = Paint()
      ..color = color.withAlpha(40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawArc(rect, 0, 2 * pi, false, trackPaint);

    // bright arc 
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 1.5 * pi, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
