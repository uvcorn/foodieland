import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.black,
    required this.text,
    this.overflow =
        TextOverflow.visible, // Ensures text wraps normally without truncation
    this.decoration,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int?
  maxLines; // This is optional and can be set to null for unlimited lines
  final TextOverflow overflow;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxLines, // If null, text will wrap freely
        overflow: overflow, // Set to visible to avoid truncation
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
          decorationColor: Colors.black,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
