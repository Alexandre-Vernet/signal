import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProxyImage extends StatelessWidget {
  final Future<Uint8List>? imageFuture;
  final String? fallbackUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ProxyImage({
    super.key,
    this.imageFuture,
    this.fallbackUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // No image
    if (imageFuture == null && (fallbackUrl == null || fallbackUrl!.isEmpty)) {
      return _placeholder();
    }

    Widget content;

    // Try proxy
    if (imageFuture != null) {
      content = FutureBuilder<Uint8List>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildImage(
              Image.memory(
                snapshot.data!,
                width: width,
                height: height,
                fit: fit,
              ),
            );
          }

          // Error proxy → fallback URL
          if (snapshot.hasError &&
              fallbackUrl != null &&
              fallbackUrl!.isNotEmpty) {
            return _buildNetworkImage();
          }

          // Loading
          return _placeholder();
        },
      );
    } else {
      // No proxy, fallback URL
      content = _buildNetworkImage();
    }

    return content;
  }

  Widget _buildNetworkImage() {
    return _buildImage(
      Image.network(
        fallbackUrl!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _placeholder();
        },
      ),
    );
  }

  Widget _buildImage(Widget image) {
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade100,
      child: Icon(Icons.image_outlined, size: 50, color: Colors.grey.shade400),
    );
  }
}
