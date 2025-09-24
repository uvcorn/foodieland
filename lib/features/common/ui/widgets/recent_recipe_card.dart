import 'package:flutter/material.dart';
import 'package:foodieland/features/common/ui/widgets/add_to_favorite_button.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_network_image/custom_network_image.dart';
import 'icon_and_title_widget.dart';

class RecentRecipeCard extends StatelessWidget {
  const RecentRecipeCard({
    super.key,
    required this.imageLink,
    required this.title,
    required this.cookingTime,
    required this.categoriesName, required this.recipeId,
  });

  final String imageLink;
  final String title;
  final String cookingTime;
  final String categoriesName;
  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        // color: AppColors.themeColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: imageLink,
                  fit: BoxFit.cover,
                  height: 150,
                  width: 250,
                ),

                Positioned(
                  right: 10,
                  top: 10,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: screenWidth * 0.035,
                    child: AddToFavoriteButton(
                      addToFavorite: (value) {},
                      screenSizeWidth: screenWidth * 0.05, recipeId: recipeId,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: Column(
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    fontSize: screenWidth * 0.03,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconAndTitleWidget(
                      icon: Icons.watch_later,
                      title: cookingTime,
                      screenWidth: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    IconAndTitleWidget(
                      icon: Icons.dining,
                      title: categoriesName,
                      screenWidth: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIconAndTitle(
    double screenWidth, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.025),
        SizedBox(width: screenWidth * 0.01),
        Text(title, style: TextStyle(fontSize: screenWidth * 0.025)),
      ],
    );
  }
}
