import 'package:flutter/material.dart';
import 'package:foodieland/features/common/ui/widgets/add_to_favorite_button.dart';
import 'package:foodieland/features/common/ui/widgets/icon_and_title_widget.dart';
import 'package:foodieland/features/common/ui/widgets/network_image_with_error_image.dart';
import 'package:foodieland/features/home/ui/controllers/recipes_list_controller.dart';
import 'package:foodieland/features/recipe_section/ui/screens/recipe_details_screen.dart';

import 'package:foodieland/utils/assets_path/assets_path.dart';
import 'package:get/get.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});
  static final String routeName = '/recipe-screen';

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Recipes")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GetBuilder<RecipesListController>(
          builder: (controller) {
            return Visibility(
              visible: controller.isProgress == false,
              replacement: Center(child: CircularProgressIndicator(),),
              child: ListView.builder(
                itemCount: controller.recipesList.length,
                itemBuilder: (context, index) {
                  final recipe = controller.recipesList[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, RecipeDetailsScreen.routeName, arguments: recipe.id);
                    },
                    child: _buildRecipesScreenCard(
                      screenSize: screenSize,
                      imageUrl: recipe.imageUrl,
                      title: recipe.title,
                      cookingTime: "${recipe.cookingTime} Minute",
                      categoriesName: recipe.category, recipeId: recipe.id,
                    ),
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
