import 'package:foodieland/features/home/data/model/recipes_list_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesController extends GetxController {
  final supabase = Supabase.instance.client;

  var favorites = <String>[].obs;
  List<RecipesListModel> favoritesList = [];
  var isLoading = false.obs;
  bool isProgress = false;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }


  Future<void> fetchFavorites() async {
    try {
      isLoading.value = true;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        favorites.clear();
        return;
      }

      final response = await supabase
          .from('favorites')
          .select('recipe_id')
          .eq('user_id', userId);

      favorites.value =
          (response as List).map((e) => e['recipe_id'] as String).toList();

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> fetchFavoritesList() async {
    try {
      isProgress = true;
      update();
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        favoritesList.clear();
        return;
      }


      final response = await supabase
          .from('favorites')
          .select('recipe_id')
          .eq('user_id', userId);

      final ids = (response as List)
          .map((e) => e['recipe_id'] as String)
          .toList();

      if (ids.isEmpty) {
        favoritesList.clear();
        return;
      }


      final recipeRes = await supabase
          .from('recipes')
          .select()
          .inFilter('id', ids);

      favoritesList = (recipeRes as List)
          .map((e) => RecipesListModel.fromMap(e as Map<String, dynamic>))
          .toList();

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isProgress = false;
      update();
    }
  }





  Future<void> addToFavorites(String itemId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase.from('favorites').insert({
        'user_id': userId,
        'recipe_id': itemId,
      });

      favorites.add(itemId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }


  Future<void> removeFromFavorites(String itemId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('recipe_id', itemId);

      favorites.remove(itemId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }


  Future<void> toggleFavorite(String itemId) async {
    if (favorites.contains(itemId)) {
      await removeFromFavorites(itemId);
    } else {
      await addToFavorites(itemId);
    }
  }

  bool isFavorite(String itemId) {
    return favorites.contains(itemId);
  }

  void clearFavorites() {
    favorites.clear();
  }

}
