import 'package:flutter/material.dart';

class ImageSourceDialog extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImageSourceDialog({
    Key? key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sélectionner une image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Appareil photo'),
            onTap: () {
              Navigator.of(context).pop();
              onCameraPressed();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galerie'),
            onTap: () {
              Navigator.of(context).pop();
              onGalleryPressed();
            },
          ),
        ],
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ImageSourceDialog(
        onCameraPressed: onCameraPressed,
        onGalleryPressed: onGalleryPressed,
      ),
    );
  }
}
