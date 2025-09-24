import 'package:foodieland/features/home/data/model/recipes_list_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RandomRecipesController extends GetxController{
  final supabase = Supabase.instance.client;

  var recipesFirstList = <RecipesListModel>[].obs;
  var recipesSecondList = <RecipesListModel>[].obs;
  bool _isProgress = false;
  bool _isProgressSecond = false;

  bool get isProgress => _isProgress;
  bool get isProgressSecond => _isProgressSecond;

  Future<void> fetchRecipesFirstList() async {
    try {
      _isProgress = true;
      update();

      final response = await supabase.from('recipes').select();

      final data = List<Map<String, dynamic>>.from(response);
      data.shuffle();
      recipesFirstList.value =
          data.take(6).map((e)  => RecipesListModel.fromMap(e)).toList();
    } catch (e) {
      print("Error fetching Data: $e");
    } finally {

    }
    _isProgress = false;
    update();
  }

  Future<void> fetchRecipesSecondList() async {
    try {
      _isProgressSecond = true;
      update();

      final response = await supabase.from('recipes').select();

      final data = List<Map<String, dynamic>>.from(response);
      data.shuffle();
      recipesSecondList.value =
          data.take(8).map((e)  => RecipesListModel.fromMap(e)).toList();
    } catch (e) {
      print("Error fetching Data: $e");
    } finally {

    }
    _isProgressSecond = false;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchRecipesFirstList();
    fetchRecipesSecondList();
  }
}