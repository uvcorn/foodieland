
import 'package:foodieland/features/home/data/model/recipes_list_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryRecipesController extends GetxController{
  final supabase = Supabase.instance.client;

  var recipesList = <RecipesListModel>[].obs;
  bool _isProgress = false;

  bool get isProgress => _isProgress;

  Future<void> fetchRecipesList({required String categoryName}) async {
    try {
      _isProgress = true;
      update();
      print(categoryName);

      final response = await supabase.from('recipes').select().eq('category', categoryName);
      print(response);

      recipesList.value =
          (response as List).map((e) => RecipesListModel.fromMap(e)).toList();
    } on PostgrestException catch (e) {

      recipesList.clear();
      print("Supabase Error: ${e.message}");
    } catch (e) {
      print("Error fetching Data: $e");
    } finally {

    }
    _isProgress = false;
    update();
  }

}