import 'package:flutter/material.dart';
import 'package:foodieland/features/common/ui/controllers/favorite_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/snackbar_helper/snackbar_helper.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../home/ui/screens/home_screen.dart';

class SignInController extends GetxController {
  // Reactive variables
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool isPasswordObscure = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signInFormKey = GlobalKey<FormState>();

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  // Toggle remember me checkbox
  void toggleRememberMe(bool? newValue) {
    rememberMe.value = newValue ?? false;
  }

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

  // Load saved credentials (if available)
  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe.value = true;
    }
  }

  // Save email and password to SharedPreferences
  Future<void> saveCredentials() async {
    if (rememberMe.value) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
    }
  }

  // Clear credentials from SharedPreferences (for example on logout)
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }

  // Sign-in logic with Supabase
  Future<void> signIn() async {
    final email = emailController.text;
    final password = passwordController.text;

    // Start loading state
    isLoading.value = true;

    try {
      // Use Supabase to sign in the user
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Check if the user is successfully authenticated
      if (response.user != null) {
        // Sign-in success, handle accordingly
        SnackbarHelper.show(
          message: 'Welcome back! You are now signed in.',
          isSuccess: true,
          backgroundColor: AppColors.primary, // Success color
          textColor: Colors.white,
        );

        // Save credentials if "Remember Me" is checked
        await saveCredentials();
        Get.find<FavoritesController>().fetchFavorites();
        // Navigate to home screen (or the appropriate screen)
        Get.offAll(() => HomeScreen());
      } else {
        // Handle the case where user is not authenticated
        SnackbarHelper.show(
          message: 'Email or password is incorrect.',
          isSuccess: false,
          backgroundColor: AppColors.red, // Failure color
          textColor: Colors.white,
        );
      }
    } on AuthException catch (e) {
      // Supabase throws an AuthException on failure
      SnackbarHelper.show(
        message: e.message,
        isSuccess: false,
        backgroundColor: AppColors.red, // Failure color
        textColor: Colors.white,
      );
    } catch (e) {
      // Handle other exceptions
      SnackbarHelper.show(
        message: 'An unexpected error occurred. Please try again.',
        isSuccess: false,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
      );
    } finally {
      // Stop loading state
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
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google,
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
          Get.find<FavoritesController>().fetchFavorites();
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
