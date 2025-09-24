import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactUsController extends GetxController {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  ContactUsController();

  // TextEditingControllers for your form fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  // Loading state
  var isLoading = false.obs;

  Future<bool> submitContactForm() async {
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      final data =
          await supabaseClient.from('contact_us').insert({
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone_number': phoneController.text.trim(),
            'message': messageController.text.trim(),
          }).select(); // .select() returns the inserted data

      print('Data inserted: $data');

      // Clear form fields on success
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      messageController.clear();

      isLoading.value = false;
      return true;
    } catch (error) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to send message: $error');
      return false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
