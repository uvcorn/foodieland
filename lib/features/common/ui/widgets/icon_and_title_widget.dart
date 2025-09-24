import 'package:flutter/material.dart';

class IconAndTitleWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final double screenWidth;

  const IconAndTitleWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.025),
        SizedBox(width: screenWidth * 0.01),
        Text(title, style: TextStyle(fontSize: screenWidth * 0.025)),
      ],
    );
  }
}
