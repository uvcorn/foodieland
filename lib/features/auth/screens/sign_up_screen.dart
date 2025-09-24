import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../components/action_button/action_button.dart';
import '../../../components/custom_checkbox/custom_checkbox.dart';
import '../../../components/custom_text_field/custom_text_field.dart';
import '../../../components/input_card_container/input_card_container.dart';
import '../controllers/sign_up_controller.dart';
import '../screens/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  static final String routeName = '/sign-up';

  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the SignUpController using Get.find()
    final signUpController = Get.find<SignUpController>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: signUpController.signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.07),
                  Text(
                    AppStrings.welcomeHere,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    AppStrings.createAccount,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    AppStrings.fillInformation,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.04),
                  InputCardContainer(
                    minHeight: 200,
                    children: [
                      CustomTextField(
                        controller: signUpController.emailController,
                        labelText: AppStrings.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: signUpController.emailValidator,
                      ),
                      CustomTextField(
                        controller: signUpController.passwordController,
                        labelText: AppStrings.password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: signUpController.passwordValidator,
                      ),
                      CustomTextField(
                        controller: signUpController.confirmPassController,
                        labelText: AppStrings.confirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: signUpController.confirmPasswordValidator,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Obx(() {
                    return CustomCheckbox(
                      showCheckbox: true,
                      value: signUpController.agreedToTerms.value,
                      onChanged:
                          (value) =>
                              signUpController.agreedToTerms.value =
                                  value ?? false,
                      leadingText: AppStrings.agreeWith,
                      clickableText: AppStrings.termsAndConditions,
                      onLinkTap: () {
                        // Navigate to terms and conditions
                      },
                    );
                  }),
                  SizedBox(height: size.height * 0.02),
                  Obx(() {
                    final bool isButtonEnabled =
                        signUpController.agreedToTerms.value &&
                        !signUpController.isLoading.value;

                    return ActionButton(
                      title: AppStrings.signUpButton,
                      onPressed:
                          isButtonEnabled
                              ? () {
                                signUpController
                                    .signUp(); // Make sure validation runs here
                              }
                              : null, // Disable the button if the form is invalid
                    );
                  }),

                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomCheckbox(
                        showCheckbox: false,
                        leadingText: AppStrings.alreadyHaveAccount,
                        clickableText: AppStrings.signInButton,
                        onLinkTap: () {
                          Navigator.pushNamed(context, SignInScreen.routeName);
                        },
                        clickableTextStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  ActionButton(
                    title: AppStrings.continueWithGoogle,
                    onPressed: () => signUpController.googleSignIn(),
                    icon: AppIcons.google,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
                  SizedBox(height: size.height * 0.06),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
