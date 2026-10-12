import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final void Function() onShake;
  final void Function(double gForce)? onReading; // live strength value
  final void Function()? onError; // sensor missing or not working

  static const double shakeThreshold = 2.5;
  static const Duration cooldown = Duration(milliseconds: 800);

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  ShakeDetector({
    required this.onShake,
    this.onReading,
    this.onError,
  });

  void start() {
    _subscription = accelerometerEventStream().listen(
      (event) {
        final magnitude =
            sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

        final gForce = magnitude / 9.81;

        onReading?.call(gForce);

        if (gForce > shakeThreshold) {
          final now = DateTime.now();
          if (now.difference(_lastShake) > cooldown) {
            _lastShake = now;
            onShake();
          }
        }
      },
      onError: (_) {
        onError?.call();
      },
      cancelOnError: false,
    );
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}
