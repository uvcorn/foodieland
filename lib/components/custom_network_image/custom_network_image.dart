// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double? size;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final BoxFit? fit;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.fit,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double resolvedHeight = height ?? size ?? 100;
    final double resolvedWidth = width ?? size ?? 100;

    // *** THIS IS THE CRUCIAL CHANGE ***
    if (imageUrl.isEmpty) {
      // Return a fallback widget if imageUrl is empty
      return Container(
        height: resolvedHeight,
        width: resolvedWidth,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: Colors.grey[200], // Default background for empty image
        ),
        child: const Icon(
          Icons.person,
          color: Colors.grey,
        ), // Default avatar icon
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder:
          (context, imageProvider) => Container(
            height: resolvedHeight,
            width: resolvedWidth,
            decoration: BoxDecoration(
              border: border,
              borderRadius: borderRadius,
              shape: boxShape,
              color: backgroundColor,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
                colorFilter: colorFilter,
              ),
            ),
            child: child,
          ),
      placeholder:
          (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.6),
            highlightColor: Colors.grey.withOpacity(0.3),
            child: Container(
              height: resolvedHeight, // Use resolved dimensions for shimmer
              width: resolvedWidth, // Use resolved dimensions for shimmer
              decoration: BoxDecoration(
                border: border,
                color: Colors.grey.withOpacity(0.6),
                borderRadius: borderRadius,
                shape: boxShape,
              ),
              child: child,
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            height: resolvedHeight, // Use resolved dimensions for error widget
            width: resolvedWidth, // Use resolved dimensions for error widget
            decoration: BoxDecoration(
              border: border,
              color: Colors.grey.withOpacity(0.6),
              borderRadius: borderRadius,
              shape: boxShape,
            ),
            child: const Icon(
              Icons.broken_image,
            ), // Changed to a more generic error icon
          ),
    );
  }
}
