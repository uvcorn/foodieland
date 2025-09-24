// file: lib/features/auth/controllers/reset_password_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../components/snackbar_helper/snackbar_helper.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../screens/sign_in_screen.dart';

class ResetPasswordController extends GetxController {
  final passwordTEController = TextEditingController();
  final confirmPassTEController = TextEditingController();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  // Corrected: Make the variable reactive using .obs
  RxBool isPasswordObscure = true.obs;

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordLength;
    }
    return null;
  }

  // Confirm password validator
  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value != passwordTEController.text) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  // Function to handle the password reset logic
  Future<void> resetPassword() async {
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: passwordTEController.text),
      );

      SnackbarHelper.show(
        message: AppStrings.passwordResetSuccess,
        isSuccess: true,
        backgroundColor: AppColors.primary,
      );

      Get.offAll(() => const SignInScreen());
    } on AuthException catch (e) {
      SnackbarHelper.show(
        message: e.message,
        isSuccess: false,
        backgroundColor: AppColors.red,
      );
    } catch (e) {
      SnackbarHelper.show(
        message: AppStrings.somethingWentWrong,
        isSuccess: false,
        backgroundColor: AppColors.red,
      );
      debugPrint('Unexpected error during password reset: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Corrected: Now that isPasswordObscure is RxBool, we use .value to access and update its boolean state.
  void togglePasswordVisibility() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  @override
  void onClose() {
    passwordTEController.dispose();
    confirmPassTEController.dispose();
    super.onClose();
  }
}
