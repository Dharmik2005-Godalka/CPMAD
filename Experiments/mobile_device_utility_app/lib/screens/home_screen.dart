import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget menuCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String route,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Utility')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          menuCard(
            context,
            Icons.camera_alt,
            'Camera & Gallery',
            'Take a photo or pick an image',
            '/image',
          ),
          menuCard(
            context,
            Icons.sensors,
            'Accelerometer',
            'Live sensor values',
            '/sensor',
          ),
          menuCard(
            context,
            Icons.location_on,
            'GPS Location',
            'Current and live location',
            '/location',
          ),
        ],
      ),
    );
  }
}
