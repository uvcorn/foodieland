import 'package:foodieland/features/home/data/model/category_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryController extends GetxController {
  final supabase = Supabase.instance.client;

  var categories = <CategoryModel>[].obs;
  List <String> categoriesName = [];
  var isLoading = false.obs;

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      update();
      final response = await supabase.from('categories').select();

      categories.value =
          (response as List).map((e) => CategoryModel.fromMap(e)).toList();
      final List<String> fetchedCategories =
      (response as List).map((item) => item['name'] as String).toList();
      categoriesName = fetchedCategories;
    } catch (e) {
      print("Error fetching Data: $e");
    } finally {
      isLoading.value = false;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}
