import 'dart:typed_data';

import 'package:flutter/material.dart';

class SourceIcon extends StatelessWidget {
  final Future<Uint8List> imageFuture;
  final String? fallbackUrl;
  final double size;

  const SourceIcon({
    super.key,
    required this.imageFuture,
    this.fallbackUrl,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: imageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ClipOval(
            child: Image.memory(
              snapshot.data!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              cacheWidth: 230,
              cacheHeight: 260,
            ),
          );
        }

        if (snapshot.hasError && fallbackUrl != null) {
          return ClipOval(
            child: Image.network(
              fallbackUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            ),
          );
        }

        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return SizedBox(
      width: size,
      height: size,
      child: Icon(Icons.public, size: size * 0.7, color: Colors.grey.shade400),
    );
  }
}
