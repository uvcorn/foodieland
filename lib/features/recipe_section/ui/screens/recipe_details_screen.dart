// lib/features/recipe_details/ui/screens/recipe_details_screen.dart

import 'package:flutter/material.dart';
import 'package:foodieland/components/custom_text/custom_text.dart';
import 'package:foodieland/features/home/ui/controllers/random_recipes_controller.dart';
import 'package:foodieland/features/recipe_section/data/controllers/recipe_controller.dart';
import 'package:foodieland/features/recipe_section/data/model/recipe_details_model.dart';
import 'package:foodieland/utils/app_colors/app_colors.dart';
import 'package:get/get.dart';
import '../../../../components/custom_network_image/custom_network_image.dart';
import '../../../../utils/app_strings/app_strings.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../common/ui/widgets/icon_and_title_widget.dart';
import '../../../common/ui/widgets/recent_recipe_card.dart';
import '../widgets/food_speciality_section.dart';
import '../widgets/ingredients_section.dart';
import '../widgets/nutrition_info_section.dart';
import '../widgets/preparation_steps_section.dart';
import 'recipe_post_screen.dart';

class RecipeDetailsScreen extends StatefulWidget {
  static final String routeName = '/recipe-details';
  final String recipeId;



  RecipeDetailsScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final RecipeController _recipeController = Get.find<RecipeController>();
    RecipeDetailsModel? recipeData;
    bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchRecipe();
  }


  Future<void> fetchRecipe() async {
    final data = await _recipeController.getRecipeById(widget.recipeId);

    setState(() {
      recipeData = data;

      isLoading = false;
    });
  }



  final List<Map<String, String>> ingredientsData = const [
    {
      'title': 'Vibrant Vegetables:',
      'description':
          'A generous mix of colorful, finely chopped vegetables like carrots, bell peppers, edamame, and broccoli, which are quickly stir-fried to maintain their crisp texture and nutritional value.',
    },
    {
      'title': 'Wholesome Rice:',
      'description':
          'Often made with brown rice or a combination of grains, providing a rich source of fiber and complex carbohydrates.',
    },
    {
      'title': 'Lean Protein:',
      'description':
          'Lean, high-quality proteins such as diced chicken breast, shrimp, or tofu are used to create a fulfilling and well-rounded meal.',
    },
    {
      'title': 'Delicate Flavor Profile:',
      'description':
          'Flavored with a light touch of low-sodium soy sauce, fresh ginger, and a hint of sesame oil, it delivers a clean, delicate umami taste without being heavy or greasy.',
    },
  ];

  final List<Map<String, String>> ingredients = [
    {'name': 'Rice', 'quantity': '1 cup'},
    {'name': 'Carrot', 'quantity': '1'},
    {'name': 'Egg', 'quantity': '2'},
    {'name': 'Soy Sauce', 'quantity': '3 tbsp'},
    {'name': 'Green Onion', 'quantity': '2 tbsp'},
  ];

  final List<String> preparationSteps = [
    'Heat a pan and add oil.',
    'Add diced vegetables and stir-fry for 3-4 minutes.',
    'Add cooked rice and soy sauce to the pan.',
    'Crack the eggs into the pan and stir until cooked.',
    'Add green onions and mix thoroughly.',
    'Serve hot and enjoy your healthy Japanese fried rice.',
  ];

  // Sample nutritional information
  final Map<String, String> nutritionInfo = {
    'Calories': '350 kcal',
    'Carbs': '45g',
    'Protein': '12g',
    'Fat': '8g',
    'Fiber': '5g',
  };

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (recipeData == null) {
      return const Scaffold(
        body: Center(child: Text("Recipe not found")),
      );
    }

    final recipe = recipeData!;
    final size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image and Back Button using Stack
              Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    height: 300,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),

              // Recipe Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: recipe.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        IconAndTitleWidget(
                          icon: Icons.watch_later,
                          title: "${recipe.cookingTime} Minutes",
                          screenWidth: screenWidth,
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        IconAndTitleWidget(
                          icon: Icons.dining,
                          title: recipe.category,
                          screenWidth: screenWidth,
                        ),
                      ],
                    ),
                    CustomText(
                      textAlign: TextAlign.left,
                      text: recipe.description,
                      fontSize: 12,
                      maxLines: null,
                    ),
                    SizedBox(height: size.height * 0.03),

                    // Food Specialty Section
                    RecipeSpecialitySection(specialityData: recipe.specialities,),
                    SizedBox(height: size.height * 0.03),

                    // Nutrition Information Section
                    NutritionInfoSection(nutritionInfo: recipe.nutritionInfo),
                    SizedBox(height: size.height * 0.03),

                    // Ingredients Section
                    IngredientsSection(ingredients: recipe.ingredients),
                    SizedBox(height: size.height * 0.03),

                    // Step-by-Step Preparation
                    PreparationStepsSection(preparationSteps: recipe.preparationSteps),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        Text(
                          AppStrings.otherRecipes,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.04,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(
                height: 210,
                child: GetBuilder<RandomRecipesController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.isProgress == false,
                      replacement: Center(child: CircularProgressIndicator(),),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.recipesFirstList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final recipe = controller.recipesFirstList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RecipeDetailsScreen.routeName,arguments: recipe.id
                                );
                              },
                              child: RecentRecipeCard(
                                imageLink: recipe.imageUrl,
                                title: recipe.title,
                                cookingTime: '${recipe.cookingTime} Minute',
                                categoriesName: recipe.category, recipeId: recipe.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, RecipePostScreen.routeName);
        },
      ),
    );
  }
}
