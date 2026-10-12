import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/info_item.dart';
import '../services/device_info_service.dart';
import '../widgets/sensor_card.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({super.key});

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  late Future<List<InfoItem>> infoFuture;

  late final Stream<List<double>> accelerometerStream;
  late final Stream<List<double>> gyroscopeStream;

  @override
  void initState() {
    super.initState();
    infoFuture = DeviceInfoService.getDeviceInfo();

    accelerometerStream =
        accelerometerEventStream().map((e) => [e.x, e.y, e.z]);
    gyroscopeStream = gyroscopeEventStream().map((e) => [e.x, e.y, e.z]);
  }

  void reload() {
    setState(() {
      infoFuture = DeviceInfoService.getDeviceInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info & Sensors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload device info',
            onPressed: reload,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Device Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          FutureBuilder<List<InfoItem>>(
            future: infoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.error_outline, color: Colors.red),
                    title: Text(snapshot.error.toString()),
                  ),
                );
              }

              final items = snapshot.data ?? [];
              return Card(
                child: Column(
                  children: items.map((item) {
                    return ListTile(
                      dense: true,
                      title: Text(item.label),
                      trailing: Flexible(
                        child: Text(
                          item.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),
          const Text(
            'Sensor Readings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          SensorCard(
            title: 'Accelerometer',
            icon: Icons.speed,
            unit: 'm/s²',
            stream: accelerometerStream,
          ),
          const SizedBox(height: 8),
          SensorCard(
            title: 'Gyroscope',
            icon: Icons.rotate_right,
            unit: 'rad/s',
            stream: gyroscopeStream,
          ),
        ],
      ),
    );
  }
}
