import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String unit;
  final Stream<List<double>> stream;

  const SensorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.unit,
    required this.stream,
  });

  Widget valueRow(String axis, double value) {
    return ListTile(
      dense: true,
      title: Text('$axis axis'),
      trailing: Text(
        '${value.toStringAsFixed(2)} $unit',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<double>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'This sensor is not available on this device.',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                // no reading yet
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Waiting for sensor data...\n'
                      '(Use an Android phone or emulator. Desktop has no sensors.)',
                    ),
                  );
                }

                final values = snapshot.data!;
                return Column(
                  children: [
                    valueRow('X', values[0]),
                    valueRow('Y', values[1]),
                    valueRow('Z', values[2]),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
