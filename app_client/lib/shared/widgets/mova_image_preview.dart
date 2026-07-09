import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MovaImagePreview extends StatelessWidget {
  const MovaImagePreview({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ExtendedImage.file(
        File(path),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
      ),
    );
  }
}
