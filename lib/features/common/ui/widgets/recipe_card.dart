import 'package:flutter/material.dart';
import 'package:foodieland/features/common/ui/widgets/add_to_favorite_button.dart';
import 'package:foodieland/utils/app_colors/app_colors.dart';
import 'package:foodieland/utils/assets_path/assets_path.dart';
import 'package:foodieland/features/common/ui/widgets/network_image_with_error_image.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                 Radius.circular(10)
                ),
                child: SizedBox(
                  height: screenHeight * 0.14,width: double.infinity,
                  child: NetworkImageWithErrorImage(
                    imageLink: imageLink,
                    errorAssets: AssetsPath.squarePhoto,
                  ),
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildIconAndTitle(
                          screenWidth,
                          icon: Icons.watch_later,
                          title: cookingTime,
                        ),
                        buildIconAndTitle(
                          screenWidth,
                          icon: Icons.dining,
                          title: categoriesName,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    );
  }

  Widget buildIconAndTitle(
    double screenWidth, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.02),
        SizedBox(width: screenWidth * 0.01),
        Text(title, style: TextStyle(fontSize: screenWidth * 0.02)),
      ],
    );
  }
}
