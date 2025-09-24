import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodieland/features/home/ui/controllers/category_controller.dart';
import 'package:foodieland/features/home/ui/controllers/random_recipes_controller.dart';
import 'package:foodieland/features/recipe_section/data/controllers/recipe_controller.dart';
import 'package:foodieland/utils/app_strings/app_strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../components/custom_dropdown_menu/custom_dropdown_menu.dart';
import '../../../../components/dynamic_textfield/dynamic_text_field_list.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../components/action_button/action_button.dart';
import '../../../../components/custom_text_field/custom_text_field.dart';
import '../../../../components/input_card_container/input_card_container.dart';
import '../../../common/ui/widgets/recent_recipe_card.dart';
import 'recipe_details_screen.dart'; // For image picking

class RecipePostScreen extends StatefulWidget {
  static final String routeName = '/recipe-post';
  const RecipePostScreen({super.key});

  @override
  State<RecipePostScreen> createState() => _RecipePostScreenState();
}

class _RecipePostScreenState extends State<RecipePostScreen> {
  final RecipeController _recipeController = Get.find<RecipeController>();
  final CategoryController _categoryController = Get.find<CategoryController>();
  final user = Supabase.instance.client.auth.currentUser;

  final _formKey = GlobalKey<FormState>();

  // Controllers for recipe details
  final TextEditingController recipeTitleController = TextEditingController();
  final TextEditingController recipeDescriptionController =
      TextEditingController();
  final TextEditingController cookingTimeController = TextEditingController();

  String? categorySelect;
  String? cookingTimeSelect;
  // Image picker
  XFile? selectedImage;

  // For dynamic ingredient, preparation, and nutrition fields
  Map<String, String> ingredientsMap = {};
  Map<String, String> preparationStepsMap = {};
  Map<String, String> foodSpecialtiesMap = {};
  Map<String, String> nutritionInfoMap = {};

  // Pick image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  List<String> cookingTimes = [
    '10 Minute',
    '20 Minute',
    '30 Minute',
    '45 Minute',
    '50 Minute',
    '60 Minute',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CategoryController().fetchCategories();
    });
  }

  @override
  void dispose() {
    recipeTitleController.dispose();
    recipeDescriptionController.dispose();
    cookingTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button and Title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(width: screenWidth * 0.15),
                      Text(
                        AppStrings.postARecipe,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Recipe Image Section with Add Button
                  GestureDetector(
                    onTap: _pickImage,
                    child:
                        selectedImage == null
                            ? Icon(
                              Icons.add_a_photo,
                              size: 80,
                              color: AppColors.black,
                            )
                            : Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                            ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Recipe Details Form
                  InputCardContainer(
                    // doubleHeightIndexes: [3],
                    minHeight: 230,
                    children: [
                      CustomTextField(
                        controller: recipeTitleController,
                        labelText: AppStrings.recipeTitle,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please Enter title";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: recipeDescriptionController,
                        labelText: AppStrings.recipeDescription,
                        textFieldLines: 3,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Please Enter Description";
                          }
                          return null;
                        },
                      ),
                      // CustomTextField(
                      //   controller: cookingTimeController,
                      //   labelText: 'Cooking Time',
                      // ),
                      CustomDropdownMenu(
                        options: cookingTimes,
                        hint: AppStrings.cookingTimeCaption,
                        hintTextColor: AppColors.mediumGray,
                        borderColor: AppColors.mediumGray,
                        selectedValue: cookingTimeSelect,

                        fontSize: 12,
                        onSelected: (value) {
                          setState(() {
                            cookingTimeSelect = value;
                          });
                        },
                      ),
                      CustomDropdownMenu(
                        options: _categoryController.categoriesName.toList(),
                        hint: AppStrings.recipeCategory,
                        hintTextColor: AppColors.mediumGray,
                        borderColor: AppColors.mediumGray,
                        selectedValue: categorySelect,
                        fontSize: 12,
                        onSelected: (value) {
                          setState(() {
                            categorySelect = value;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.015),

                  // Dynamic Ingredients Section with Add button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DynamicTextFieldList(
                        fieldLabel: 'Ingredient',
                        initialValues: ingredientsMap,
                        minFields: 1,
                        addAnotherLabel: 'Add Ingredient',
                        titleHintText: 'Ingredient Name',
                        descriptionHintText: 'Ingredient Quantity',
                        onDataChanged: (data) {
                          setState(() {
                            ingredientsMap = data;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DynamicTextFieldList(
                        isListData: true,
                        fieldLabel: 'Preparation Step',
                        initialValues: preparationStepsMap,
                        minFields: 1,
                        addAnotherLabel: 'Add Preparation Step',
                        titleHintText: 'Enter preparation step',
                        descriptionHintText: '',
                        onDataChanged: (data) {
                          setState(() {
                            preparationStepsMap = data;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DynamicTextFieldList(
                        fieldLabel: 'Food Specialty',
                        initialValues: foodSpecialtiesMap,
                        minFields: 1,
                        addAnotherLabel: 'Add Food Specialty',
                        titleHintText: 'Enter Title',
                        descriptionHintText: 'Enter Description',
                        onDataChanged: (data) {
                          setState(() {
                            foodSpecialtiesMap = data;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DynamicTextFieldList(
                        fieldLabel: 'Nutrition Info',
                        initialValues: nutritionInfoMap,
                        minFields: 1,
                        addAnotherLabel: 'Add Nutrition Info',
                        titleHintText: 'Nutrition Name',
                        descriptionHintText: 'Nutrition Quantity',
                        onDataChanged: (data) {
                          setState(() {
                            nutritionInfoMap = data;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Post Recipe Button
                  GetBuilder(
                    init: _recipeController,
                    builder: (controller) {
                      return Visibility(
                        visible: controller.isLoading == false,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: ActionButton(
                          height: 45,
                          backgroundColor: AppColors.black,
                          title: AppStrings.postRecipe,
                          onPressed: _postRecipe,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Optional: Display recent recipes section
                  Row(
                    children: [
                      Text(
                        AppStrings.recentRecipes,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.04,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 210,
                    child: GetBuilder<RandomRecipesController>(
                      builder: (controller) {
                        return Visibility(
                          visible: controller.isProgress == false,
                          replacement: Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.recipesFirstList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final recipe = controller.recipesFirstList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RecipeDetailsScreen.routeName,
                                      arguments: recipe.id,
                                    );
                                  },
                                  child: RecentRecipeCard(
                                    imageLink: recipe.imageUrl,
                                    title: recipe.title,
                                    cookingTime: '${recipe.cookingTime} Minute',
                                    categoriesName: recipe.category,
                                    recipeId: recipe.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _postRecipe() async {
    if (_formKey.currentState!.validate()) {
      if (selectedImage != null) {
        final rawText = cookingTimeSelect;
        final cleanedText = rawText?.replaceAll(RegExp(r'[^0-9]'), '');
        final cookingTime =
            cleanedText!.isNotEmpty ? int.parse(cleanedText) : 0;
        await _recipeController.postRecipe(
          userId: user!.id,
          title: recipeTitleController.text,
          description: recipeDescriptionController.text,
          category: categorySelect!,
          cookingTime: cookingTime,
          imageFile: File(selectedImage!.path),
          ingredients: ingredientsMap,
          steps: preparationStepsMap,
          specialties: foodSpecialtiesMap,
          nutrition: nutritionInfoMap,
        );

        _clearAllData();
        setState(() {});
      } else {
        Get.snackbar("Error", "Please Select Image First ");
      }
    } else {
      Get.snackbar("Error", "Please fill up all Form ");
    }
  }

  void _clearAllData() {
    recipeTitleController.clear();
    recipeDescriptionController.clear();
    categorySelect = null;
    cookingTimeSelect = null;
    selectedImage = null;
    ingredientsMap.clear();
    preparationStepsMap.clear();
    foodSpecialtiesMap.clear();
    nutritionInfoMap.clear();
  }
}
