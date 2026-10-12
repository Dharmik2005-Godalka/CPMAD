import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? position;
  String? errorMessage;
  bool showSettingsButton = false;
  bool isLoading = false;
  StreamSubscription<Position>? subscription;

  static const LocationSettings settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  bool get isLive => subscription != null;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  // checks GPS and permission, returns true if we can read the location
  Future<bool> checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        errorMessage = 'Location service is turned off. Please turn on GPS.';
        showSettingsButton = false;
      });
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      setState(() {
        errorMessage =
            'Location permission denied. The app cannot show your location without it.';
        showSettingsButton = false;
      });
      return false;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        errorMessage =
            'Location permission is permanently denied. Please enable it in app settings.';
        showSettingsButton = true;
      });
      return false;
    }

    setState(() {
      errorMessage = null;
      showSettingsButton = false;
    });
    return true;
  }

  Future<void> getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    if (await checkPermission()) {
      try {
        final result = await Geolocator.getCurrentPosition(
          locationSettings: settings,
        );
        if (!mounted) return;
        setState(() {
          position = result;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          errorMessage = 'Could not get the location: $e';
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // live updates using a position stream
  Future<void> toggleLive() async {
    if (isLive) {
      await subscription!.cancel();
      if (!mounted) return;
      setState(() {
        subscription = null;
      });
      return;
    }

    if (!await checkPermission()) return;

    subscription = Geolocator.getPositionStream(locationSettings: settings)
        .listen((result) {
      setState(() {
        position = result;
      });
    });
    if (mounted) setState(() {});
  }

  Widget infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Location')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (errorMessage != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    if (showSettingsButton)
                      TextButton(
                        onPressed: () {
                          Geolocator.openAppSettings();
                        },
                        child: const Text('Open Settings'),
                      ),
                  ],
                ),
              ),
            ),
          Card(
            child: position == null
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No location yet')),
                  )
                : Column(
                    children: [
                      infoTile(
                        Icons.explore,
                        'Latitude',
                        position!.latitude.toStringAsFixed(6),
                      ),
                      infoTile(
                        Icons.explore_outlined,
                        'Longitude',
                        position!.longitude.toStringAsFixed(6),
                      ),
                      infoTile(
                        Icons.gps_fixed,
                        'Accuracy',
                        '${position!.accuracy.toStringAsFixed(1)} m',
                      ),
                      infoTile(
                        Icons.terrain,
                        'Altitude',
                        '${position!.altitude.toStringAsFixed(1)} m',
                      ),
                      infoTile(
                        Icons.access_time,
                        'Time',
                        '${position!.timestamp.hour.toString().padLeft(2, '0')}:'
                            '${position!.timestamp.minute.toString().padLeft(2, '0')}:'
                            '${position!.timestamp.second.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isLoading ? null : getCurrentLocation,
            icon: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
            label: const Text('Get Current Location'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: toggleLive,
            icon: Icon(isLive ? Icons.stop : Icons.play_arrow),
            label: Text(isLive ? 'Stop Live Updates' : 'Start Live Updates'),
          ),
        ],
      ),
    );
  }
}
