import 'package:foodieland/features/home/data/model/sliders_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SlidersController extends GetxController {
  final supabase = Supabase.instance.client;

  var sliders = <SlidersModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchSliders() async {
    try {
      isLoading.value = true;
      update();
      final response = await supabase.from('sliders').select();

      sliders.value =
          (response as List).map((e) => SlidersModel.fromMap(e)).toList();
    } catch (e) {
      print("Error fetching sliders: $e");
    } finally {
      isLoading.value = false;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchSliders();
  }
}
