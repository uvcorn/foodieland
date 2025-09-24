import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../components/snackbar_helper/snackbar_helper.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../screens/otp_verify_screen.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  final emailController = TextEditingController();

  // Send OTP for password reset
  Future<void> sendOtpForPasswordReset(String email) async {
    isLoading.value = true;
    try {
      // Using Supabase method for resetting password instead of resend
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      SnackbarHelper.show(
        message: AppStrings.otpSent,
        isSuccess: true,
        backgroundColor: AppColors.primary,
      );
      Get.to(() => OtpVerifyScreen(email: email, isSignUp: false));
    } on AuthException catch (e) {
      // Specific error handling
      SnackbarHelper.show(
        message: e.message,
        isSuccess: false,
        backgroundColor: AppColors.red,
      );
    } catch (e) {
      // General error handling
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

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   super.onClose();
  // }
}
