import 'dart:async';
import 'package:flutter/material.dart';
import '../services/shake_detector.dart';

class ShakeScreen extends StatefulWidget {
  const ShakeScreen({super.key});

  @override
  State<ShakeScreen> createState() => _ShakeScreenState();
}

class _ShakeScreenState extends State<ShakeScreen> {
  late final ShakeDetector detector;
  Timer? resetTimer;

  int shakeCount = 0;
  DateTime? lastShakeTime;
  bool showShakeMessage = false; // true for 2 seconds after a shake
  bool sensorError = false;
  double gForce = 1.0;

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector(
      onShake: handleShake,
      onReading: (value) {
        if (mounted) setState(() => gForce = value);
      },
      onError: () {
        if (mounted) setState(() => sensorError = true);
      },
    );
    detector.start();
  }

  @override
  void dispose() {
    detector.stop();
    resetTimer?.cancel();
    super.dispose();
  }

  // called when a shake is detected (or when the test button is pressed)
  void handleShake() {
    if (!mounted) return;

    setState(() {
      shakeCount++;
      lastShakeTime = DateTime.now();
      showShakeMessage = true;
    });

    // hide the "Shake detected" message after 2 seconds
    resetTimer?.cancel();
    resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => showShakeMessage = false);
    });
  }

  void resetAll() {
    resetTimer?.cancel();
    setState(() {
      shakeCount = 0;
      lastShakeTime = null;
      showShakeMessage = false;
    });
  }

  // 14:05:09 style time
  String formatTime(DateTime time) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = showShakeMessage ? Colors.pink : Colors.grey;

    return Scaffold(
      appBar: AppBar(title: const Text('Shake Detector')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // sensor not available message
            if (sensorError)
              Card(
                color: Colors.red.shade50,
                child: const ListTile(
                  leading: Icon(Icons.error_outline, color: Colors.red),
                  title: Text('Accelerometer not available'),
                  subtitle: Text(
                    'Run this app on an Android phone or emulator. '
                    'Desktop Chrome has no motion sensor.',
                  ),
                ),
              ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        showShakeMessage ? Icons.vibration : Icons.smartphone,
                        size: 80,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      showShakeMessage ? 'Shake detected!' : 'Shake your phone',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.numbers),
                            title: const Text('Shake count'),
                            trailing: Text(
                              '$shakeCount',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: const Text('Last shake'),
                            trailing: Text(
                              lastShakeTime == null
                                  ? '-'
                                  : formatTime(lastShakeTime!),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.speed),
                            title: const Text('Current force'),
                            trailing: Text('${gForce.toStringAsFixed(2)} g'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    onPressed: resetAll,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Test shake'),
                    onPressed: handleShake,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
