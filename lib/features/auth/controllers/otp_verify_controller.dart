import 'package:flutter/material.dart';
import 'package:foodieland/features/auth/screens/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../components/snackbar_helper/snackbar_helper.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../screens/reset_password_screen.dart';

class OtpVerifyController extends GetxController {
  // Reactive variables

  RxBool isLoading = false.obs;

  final otpTEController = TextEditingController();

  // Function to verify OTP

  Future<void> verifyOtp(
    String otp,

    String email, {

    bool isSignUp = true,
  }) async {
    isLoading.value = true;

    try {
      otpTEController.clear();
      await Supabase.instance.client.auth.verifyOTP(
        email: email,

        token: otp,

        type: isSignUp ? OtpType.signup : OtpType.recovery,
      );

      SnackbarHelper.show(
        message: AppStrings.otpVerified,

        isSuccess: true,

        backgroundColor: AppColors.primary,
      );

      Get.toNamed(
        isSignUp ? SignInScreen.routeName : ResetPasswordScreen.routeName,
      );
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
    } finally {
      isLoading.value = false;
    }
  }

  // Function to request a new OTP for sign-up only

  Future<void> resendSignUpOtp(String email) async {
    isLoading.value = true;

    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,

        email: email,
      );

      SnackbarHelper.show(
        message: AppStrings.otpSent, // Assuming you have this string

        isSuccess: true,

        backgroundColor: AppColors.primary,
      );
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
    } finally {
      isLoading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   otpTEController.dispose();

  //   super.onClose();
  // }
}
