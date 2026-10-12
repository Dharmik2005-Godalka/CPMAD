import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  StreamSubscription<AccelerometerEvent>? subscription;
  AccelerometerEvent? event;
  String? errorMessage;

  bool get isListening => subscription != null;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  // listen to the accelerometer stream
  void startListening() {
    subscription = accelerometerEventStream().listen(
      (data) {
        setState(() {
          event = data;
        });
      },
      onError: (error) {
        setState(() {
          errorMessage = 'Accelerometer is not available on this device';
          subscription = null;
        });
      },
    );
  }

  void stopListening() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Widget axisCard(String axis, double? value) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(axis)),
        title: Text('$axis axis'),
        trailing: Text(
          value == null ? '--' : '${value.toStringAsFixed(2)} m/s²',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final x = event?.x ?? 0;
    final y = event?.y ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Accelerometer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            axisCard('X', event?.x),
            axisCard('Y', event?.y),
            axisCard('Z', event?.z),
            const SizedBox(height: 12),

            // ball moves when the device is tilted
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Align(
                alignment: Alignment(
                  (-x / 10).clamp(-1.0, 1.0).toDouble(),
                  (y / 10).clamp(-1.0, 1.0).toDouble(),
                ),
                child: const Icon(
                  Icons.circle,
                  size: 40,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red))
            else if (event == null)
              const Text('Waiting for sensor data... move the device.'),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (isListening) {
                      stopListening();
                    } else {
                      errorMessage = null;
                      startListening();
                    }
                  });
                },
                icon: Icon(isListening ? Icons.stop : Icons.play_arrow),
                label: Text(isListening ? 'Stop' : 'Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
