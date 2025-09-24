import 'package:flutter/material.dart';

class NetworkImageWithErrorImage extends StatelessWidget {
  const NetworkImageWithErrorImage({
    super.key,
    required this.imageLink,
    required this.errorAssets,
    this.opacity,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String? imageLink;
  final String errorAssets;
  final double? width;
  final double? height;
  final Animation<double>? opacity;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {

    if (imageLink == null || imageLink!.isEmpty) {
      return Image.asset(
        errorAssets,
        width: width,
        height: height,
        fit: fit,
        opacity: opacity,
      );
    }

    return Image.network(
      imageLink!,
      fit: fit,
      height: height,
      width: width,
      opacity: opacity,
      errorBuilder: (_, __, ___) {

        return Image.asset(
          errorAssets,
          width: width,
          height: height,
          fit: fit,
          opacity: opacity,
        );
      },
    );
  }
}
