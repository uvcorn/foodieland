import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../components/action_button/action_button.dart';
import '../../../components/custom_checkbox/custom_checkbox.dart';
import '../../../components/custom_text_field/custom_text_field.dart';
import '../../../components/input_card_container/input_card_container.dart';
import 'forget_password_screen.dart';
import 'sign_up_screen.dart';
import '../controllers/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const String routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    final signInController = Get.find<SignInController>();

    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.08),
                Text(
                  AppStrings.welcomeMessage,
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: size.width * 0.06,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Form(
                  key: signInController.signInFormKey,
                  child: InputCardContainer(
                    minHeight: size.height * 0.14,
                    children: [
                      CustomTextField(
                        controller: signInController.emailController,
                        labelText: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: signInController.emailValidator,
                      ),
                      // The password text field needs to be wrapped in an Obx
                      // to react to changes in password visibility.
                      Obx(
                        () => CustomTextField(
                          controller: signInController.passwordController,
                          labelText: AppStrings.password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: signInController.isPasswordObscure.value,
                          enableValidation: true,
                          onToggleObscureText:
                              signInController.togglePasswordVisibility,
                          validator: signInController.passwordValidator,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                // The CustomCheckbox needs to be wrapped in an Obx
                // to react to changes in the `rememberMe` value.
                Obx(
                  () => CustomCheckbox(
                    showCheckbox: true,
                    value: signInController.rememberMe.value,
                    onChanged: signInController.toggleRememberMe,
                    leadingText: AppStrings.rememberMe,
                    leadingTextStyle: textTheme.bodySmall?.copyWith(
                      color: AppColors.black,
                    ),
                    clickableText: AppStrings.forgotPassword,
                    clickableTextStyle: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    useSpaceBetweenAlignment: true,
                    onLinkTap: () {
                      Navigator.pushNamed(
                        context,
                        ForgotPasswordScreen.routeName,
                      );
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Obx(() {
                  return ActionButton(
                    title: AppStrings.continueButton,
                    onPressed:
                        signInController.isLoading.value
                            ? null
                            : () {
                              if (signInController.signInFormKey.currentState!
                                  .validate()) {
                                signInController.signIn();
                              }
                            },
                  );
                }),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCheckbox(
                      showCheckbox: false,
                      leadingText: AppStrings.createAnAccount,
                      clickableText: AppStrings.signUpButton,
                      onLinkTap: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      clickableTextStyle: textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.06),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: AppColors.borderGray,
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                      ),
                      child: Text(
                        AppStrings.orSeparator,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: size.width * 0.04,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: AppColors.borderGray,
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                ActionButton(
                  title: AppStrings.continueWithGoogle,
                  onPressed: () => signInController.googleSignIn(),
                  icon: AppIcons.google,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
