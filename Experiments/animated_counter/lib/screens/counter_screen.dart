import 'dart:math';
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen>
  with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  int target = 0; 
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void changeTo(int newValue) {
    final from = animation.value;

    setState(() {
      target = newValue;
      animation = Tween<double>(begin: from, end: newValue.toDouble()).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    });

    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Counter'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Counter Value',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            AnimatedBuilder(
              animation: controller,
              builder: (context, child) 
              {
                final scale = 1 + 0.25 * sin(pi * controller.value);

                return Transform.scale(
                  scale: scale,
                  child: Text(
                    animation.value.round().toString(),
                    style: const TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: 
              [
                ElevatedButton
                (
                  onPressed: () => changeTo(target - 1),
                  child: const Text('-1'),
                ),

                ElevatedButton
                (
                  onPressed: () => changeTo(target + 1),
                  child: const Text('+1'),
                ),

                ElevatedButton
                (
                  onPressed: () => changeTo(target + 10),
                  child: const Text('+10'),
                ),

                ElevatedButton
                (
                  onPressed: () => changeTo(target + 100),
                  child: const Text('+100'),
                ),

                OutlinedButton
                (
                  onPressed: () => changeTo(0),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
