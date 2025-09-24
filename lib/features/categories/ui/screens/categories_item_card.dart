// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:foodieland/features/common/ui/widgets/network_image_with_error_image.dart';
import 'package:foodieland/utils/assets_path/assets_path.dart';

class CategoriesItemCard extends StatelessWidget {
  const CategoriesItemCard({
    super.key,
    required this.imageLink,
    required this.title,
    required this.onTap,
  });

  final String imageLink;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: NetworkImageWithErrorImage(
                imageLink: imageLink,
                errorAssets: AssetsPath.squarePhoto,
              ),
            ),
            const SizedBox(height: 05),
            Expanded(
              flex: 1,
              child: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
