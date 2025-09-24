import 'dart:io';
import 'package:foodieland/features/recipe_section/data/model/recipe_details_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var isLoadingGetData = false.obs;

  /// Get full recipe details by ID
  Future<RecipeDetailsModel?> getRecipeById(String recipeId) async {
    try {
      isLoadingGetData.value = true;

      final response =
          await supabase
              .from('recipes')
              .select('''
      id,
      title,
      description,
      image_url,
      cooking_time,
      category,
      created_at,

      ingredients (
        id,
        name,
        quantity
      ),

      preparation_steps (
        id,
        step_order,
        title,
        description
      ),

      food_specialities (
        id,
        title,
        description
      ),

      nutrition_info (
        id,
        title,
        description
      )
    ''')
              .eq('id', recipeId)
              .single();

      return RecipeDetailsModel.fromJson(response);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadingGetData.value = false;
    }
  }

  /// Upload image to Supabase Storage
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final fileName = "${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      await supabase.storage.from('recipe-images').upload(fileName, imageFile);

      final publicUrl = supabase.storage
          .from('recipe-images')
          .getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      Get.snackbar("Image Upload Failed", e.toString());
      return null;
    }
  }

  /// Post full recipe with all related data
  Future<void> postRecipe({
    required String userId,
    required String title,
    required String description,
    required String category,
    required int cookingTime,
    required File? imageFile,
    required Map<String, String> ingredients,
    required Map<String, String> steps,
    required Map<String, String> specialties,
    required Map<String, String> nutrition,
  }) async {
    try {
      isLoading.value = true;

      // 1. Upload image if exists
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile, userId);
      }

      // 2. Insert recipe
      final recipeRes =
          await supabase
              .from('recipes')
              .insert({
                'user_id': userId,
                'title': title,
                'description': description,
                'category': category.toLowerCase(),
                'cooking_time': cookingTime,
                'image_url': imageUrl,
              })
              .select('id')
              .single();

      final recipeId = recipeRes['id'];

      // 3. Insert ingredients
      if (ingredients.isNotEmpty) {
        final ingredientList =
            ingredients.entries
                .map(
                  (e) => {
                    'recipe_id': recipeId,
                    'name': e.key,
                    'quantity': e.value,
                  },
                )
                .toList();
        await supabase.from('ingredients').insert(ingredientList);
      }

      // 4. Insert steps
      if (steps.isNotEmpty) {
        int order = 1;
        final stepList =
            steps.entries
                .map(
                  (e) => {
                    'recipe_id': recipeId,
                    'step_order': order++,
                    'title': e.key,
                    'description': e.value,
                  },
                )
                .toList();
        await supabase.from('preparation_steps').insert(stepList);
      }

      // 5. Insert food specialties
      if (specialties.isNotEmpty) {
        final specialtyList =
            specialties.entries
                .map(
                  (e) => {
                    'recipe_id': recipeId,
                    'title': e.key,
                    'description': e.value,
                  },
                )
                .toList();
        await supabase.from('food_specialities').insert(specialtyList);
      }

      // 6. Insert nutrition info
      if (nutrition.isNotEmpty) {
        final nutritionList =
            nutrition.entries
                .map(
                  (e) => {
                    'recipe_id': recipeId,
                    'title': e.key,
                    'description': e.value,
                  },
                )
                .toList();
        await supabase.from('nutrition_info').insert(nutritionList);
      }

      Get.snackbar("Success", "Recipe posted successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
