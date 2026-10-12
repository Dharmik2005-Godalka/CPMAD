import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Asks for camera permission. Returns true if allowed.
  // If it is denied, a message is shown and false is returned.
  static Future<bool> requestCamera(BuildContext context) async {
    if (kIsWeb) return true; // the browser asks for permission by itself

    final status = await Permission.camera.request();
    if (status.isGranted) return true;

    if (!context.mounted) return false;

    if (status.isPermanentlyDenied) {
      showMessage(
        context,
        'Camera permission is permanently denied. Please enable it in app settings.',
        openSettings: true,
      );
    } else {
      showMessage(
        context,
        'Camera permission denied. You cannot take a photo without it.',
      );
    }
    return false;
  }

  // Shows a message at the bottom, with an optional Settings button
  static void showMessage(
    BuildContext context,
    String text, {
    bool openSettings = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 5),
        action: openSettings
            ? SnackBarAction(label: 'Settings', onPressed: openAppSettings)
            : null,
      ),
    );
  }
}
