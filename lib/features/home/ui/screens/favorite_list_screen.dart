// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:foodieland/features/common/ui/controllers/favorite_controller.dart';
import 'package:foodieland/features/common/ui/widgets/add_to_favorite_button.dart';
import 'package:foodieland/features/common/ui/widgets/icon_and_title_widget.dart';
import 'package:foodieland/features/common/ui/widgets/network_image_with_error_image.dart';
import 'package:foodieland/utils/assets_path/assets_path.dart';
import 'package:get/get.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});
  static final String routeName = '/favorite-list-screen';

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  final FavoritesController _favoritesController = Get.find<FavoritesController>();

 @override
  void initState() {
    super.initState();
    _favoritesController.fetchFavoritesList();
  }

  @override
  Widget build(BuildContext context) {


    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Favorite List")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GetBuilder<FavoritesController>(
          builder: (controller) {
            return Visibility(
              visible: controller.isProgress == false,
              replacement: Center(child: CircularProgressIndicator(),),
              child: ListView.builder(
                itemCount: controller.favoritesList.length,
                itemBuilder: (context, index) {
                  final item = controller.favoritesList[index];
                  return _buildRecipesScreenCard(
                    screenSize: screenSize,
                    imageUrl: item.imageUrl,
                    title: item.title,
                    cookingTime: "${item.cookingTime} Minute",
                    categoriesName: item.category, recipeId: item.id,
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildRecipesScreenCard({
    required Size screenSize,
    required String imageUrl,
    required String title,
    required String cookingTime,
    required String categoriesName,
    required String recipeId,
  }) {
    return Card(
      elevation: 3,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              child: NetworkImageWithErrorImage(
                imageLink: imageUrl,
                errorAssets: AssetsPath.squarePhoto,height: 80,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.04,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconAndTitleWidget(
                        icon: Icons.watch_later,
                        title: cookingTime,
                        screenWidth: screenSize.width * 1.2,
                      ),
                      IconAndTitleWidget(
                        icon: Icons.dining,
                        title: categoriesName,
                        screenWidth: screenSize.width * 1.2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AddToFavoriteButton(
            addToFavorite: (value) {},
            screenSizeWidth: screenSize.width * 0.05, recipeId: recipeId,
          ),
        ],
      ),
    );
  }
}
