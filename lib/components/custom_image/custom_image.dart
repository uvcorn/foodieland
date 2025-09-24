// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomImage extends StatelessWidget {
  final String imageSrc;
  final Color? imageColor;
  final double? size;
  final double? sizeWidth;
  final double? sizeHeight;
  final BoxFit? fit;
  final double horizontal;
  final double vertical;

  const CustomImage({
    required this.imageSrc,
    this.imageColor,
    this.size,
    this.sizeWidth,
    this.sizeHeight,
    this.fit,
    this.horizontal = 0.0,
    this.vertical = 0.0,
    super.key,
  });

  bool get _isSvg => imageSrc.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final double? width = sizeWidth ?? size;
    final double? height = sizeHeight ?? size;

    Widget imageWidget = _isSvg
        ? SvgPicture.asset(
            imageSrc,
            color: imageColor,
            width: width,
            height: height,
            fit: fit ?? BoxFit.contain,
          )
        : Image.asset(
            imageSrc,
            color: imageColor,
            width: width,
            height: height,
            fit: fit,
          );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: imageWidget,
    );
  }
}
