import 'package:flutter/material.dart';

class MovaImageThumbnail extends StatelessWidget {
  const MovaImageThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const SizedBox.square(
        dimension: 48,
        child: Icon(Icons.image_outlined),
      ),
    );
  }
}
