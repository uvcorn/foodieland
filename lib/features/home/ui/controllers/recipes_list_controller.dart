import 'package:foodieland/features/home/data/model/recipes_list_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipesListController extends GetxController {
  final supabase = Supabase.instance.client;

  var recipesList = <RecipesListModel>[].obs;
  bool _isProgress = false;

  bool get isProgress => _isProgress;

  Future<void> fetchRecipesList() async {
    try {
      _isProgress = true;
      update();

      final response = await supabase.from('recipes').select();

      recipesList.value =
          (response as List).map((e) => RecipesListModel.fromMap(e)).toList();
    } catch (e) {
      print("Error fetching Data: $e");
    } finally {

    }
    _isProgress = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchRecipesList();
  }
}
