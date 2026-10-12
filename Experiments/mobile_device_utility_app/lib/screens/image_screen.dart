import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/permission_service.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final ImagePicker picker = ImagePicker();
  Uint8List? imageBytes;
  String? imageName;

  Future<void> pickImage(ImageSource source) async {
    // camera needs a runtime permission, gallery uses the system picker
    if (source == ImageSource.camera) {
      final allowed = await PermissionService.requestCamera(context);
      if (!allowed) return;
    }

    try {
      final file = await picker.pickImage(source: source, imageQuality: 80);
      if (file == null) return; // user cancelled

      final bytes = await file.readAsBytes();
      if (!mounted) return;

      // a new image replaces the old one
      setState(() {
        imageBytes = bytes;
        imageName = file.name;
      });
    } catch (e) {
      if (!mounted) return;
      PermissionService.showMessage(context, 'Could not get the image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera & Gallery')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageBytes == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 80, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No image selected'),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(imageBytes!, fit: BoxFit.contain),
                    ),
            ),
            const SizedBox(height: 8),
            if (imageBytes != null)
              Text(
                '$imageName  (${(imageBytes!.length / 1024).toStringAsFixed(1)} KB)',
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            if (imageBytes != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    imageBytes = null;
                    imageName = null;
                  });
                },
                icon: const Icon(Icons.delete),
                label: const Text('Remove Image'),
              ),
          ],
        ),
      ),
    );
  }
}
