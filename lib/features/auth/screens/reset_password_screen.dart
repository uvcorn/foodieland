// file: lib/features/auth/screens/reset_password_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../components/action_button/action_button.dart';
import '../../../components/custom_text_field/custom_text_field.dart';
import '../../../components/input_card_container/input_card_container.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String routeName = '/reset-password-screen';
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resetPasswordController = Get.find<ResetPasswordController>();
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: SingleChildScrollView(
            child: Form(
              key: resetPasswordController.resetPasswordFormKey,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.1),
                  Text(
                    AppStrings.resetPasswordHeader,
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    AppStrings.passwordRequirement,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.04),
                  InputCardContainer(
                    minHeight: size.height * 0.16,
                    children: [
                      Obx(
                        () => CustomTextField(
                          controller:
                              resetPasswordController.passwordTEController,
                          labelText: AppStrings.newPassword,
                          keyboardType: TextInputType.visiblePassword,
                          // CORRECTED: Get the value from the reactive variable
                          obscureText:
                              resetPasswordController.isPasswordObscure.value,
                          enableValidation: true,
                          onToggleObscureText:
                              resetPasswordController.togglePasswordVisibility,
                          validator: resetPasswordController.passwordValidator,
                        ),
                      ),
                      Obx(
                        () => CustomTextField(
                          controller:
                              resetPasswordController.confirmPassTEController,
                          labelText: AppStrings.confirmNewPassword,
                          keyboardType: TextInputType.visiblePassword,
                          confirmPasswordController:
                              resetPasswordController.passwordTEController,
                          // CORRECTED: Get the value from the reactive variable
                          obscureText:
                              resetPasswordController.isPasswordObscure.value,
                          enableValidation: true,
                          onToggleObscureText:
                              resetPasswordController.togglePasswordVisibility,
                          validator:
                              resetPasswordController.confirmPasswordValidator,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.4),
                  Obx(
                    () => ActionButton(
                      title: AppStrings.resetPassword,
                      onPressed:
                          resetPasswordController.isLoading.value
                              ? null
                              : resetPasswordController.resetPassword,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
