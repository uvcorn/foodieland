import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../components/snackbar_helper/snackbar_helper.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../home/ui/screens/home_screen.dart';
import '../screens/otp_verify_screen.dart';
import 'otp_verify_controller.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool agreedToTerms = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  // Validators
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailcantempty;
    }
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(value)) {
      return AppStrings.entervalidmail;
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordRequirement;
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmpasswordrequird;
    }
    // Confirm password length and matching validation.
    if (value.length < 6) {
      return AppStrings
          .passwordRequirement; // Ensure confirm password is at least 6 characters
    }
    if (value != passwordController.text) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  // Sign-up logic with Supabase (Email)
  Future<void> signUp() async {
    if (signUpFormKey.currentState == null ||
        !signUpFormKey.currentState!.validate()) {
      return;
    }

    if (!agreedToTerms.value) {
      SnackbarHelper.show(
        message: AppStrings.agreesignupterms,
        isSuccess: false,
        backgroundColor: AppColors.red,
      );
      return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    isLoading.value = true;

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        SnackbarHelper.show(
          message:
              'Registration successful! Please check your email for a confirmation link.',
          isSuccess: true,
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
        );
        Get.to(
          () => OtpVerifyScreen(email: email),
          binding: BindingsBuilder(() {
            Get.lazyPut<OtpVerifyController>(() => OtpVerifyController());
          }),
        );
      } else if (response.session == null && response.user == null) {
        SnackbarHelper.show(
          message: 'Please check your email to complete the registration.',
          isSuccess: true,
          backgroundColor: AppColors.lightBlue,
          textColor: Colors.white,
        );
      }
    } on AuthException catch (e) {
      SnackbarHelper.show(
        message: e.message,
        isSuccess: false,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      SnackbarHelper.show(
        message: 'An unexpected error occurred. Please try again.',
        isSuccess: false,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    try {
      // Show a loading indicator
      isLoading.value = true;
      SnackbarHelper.show(
        message: 'Starting Google Sign-In...',
        isSuccess: true,
        backgroundColor: AppColors.lightBlue,
        textColor: Colors.white,
      );

      // Step 1: Trigger Google Sign-In using Supabase OAuth method
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
      );

      // Step 2: Check if the user is logged in
      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        if (event == AuthChangeEvent.signedIn && session != null) {
          SnackbarHelper.show(
            message: 'Google Sign-In successful!',
            isSuccess: true,
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          );
          Get.offAllNamed(HomeScreen.routeName);
        }
      });
    } on AuthException catch (e) {
      // Handle specific authentication error
      SnackbarHelper.show(
        message: 'Authentication error: ${e.message}',
        isSuccess: false,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      // Catch any unexpected errors
      SnackbarHelper.show(
        message:
            'An unexpected error occurred during Google Sign-In: ${e.toString()}',
        isSuccess: false,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
