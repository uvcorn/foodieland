import 'package:flutter/material.dart';
import 'package:foodieland/features/categories/ui/controllers/category_recipes_controller.dart';
import 'package:foodieland/features/common/ui/widgets/recipe_card.dart';
import 'package:foodieland/features/recipe_section/ui/screens/recipe_details_screen.dart';
import 'package:get/get.dart';

class CategoriesItemsListScreen extends StatefulWidget {
  const CategoriesItemsListScreen({super.key, required this.categoryName});
  static final String routeName = '/categories-items-list';
  final String categoryName;

  @override
  State<CategoriesItemsListScreen> createState() =>
      _CategoriesItemsListScreenState();
}

class _CategoriesItemsListScreenState extends State<CategoriesItemsListScreen> {
  final CategoryRecipesController _recipesController =
      Get.find<CategoryRecipesController>();

  @override
  void initState() {
    super.initState();
    _recipesController.fetchRecipesList(
      categoryName: widget.categoryName.toLowerCase(),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GetBuilder(
          init: _recipesController,
          builder: (controller) {
            if (controller.isProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.recipesList.isEmpty) {
              return Center(child: Text("Empty Data"));
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.9,
                ),
                itemCount: controller.recipesList.length,
                itemBuilder: (context, index) {
                  final recipe = controller.recipesList[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, RecipeDetailsScreen.routeName,arguments: recipe.id);
                    },
                    child: RecipeCard(
                      imageLink: recipe.imageUrl,
                      title: recipe.title,
                      cookingTime: " ${recipe.cookingTime} Minute",
                      categoriesName: recipe.category, recipeId: recipe.id,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
