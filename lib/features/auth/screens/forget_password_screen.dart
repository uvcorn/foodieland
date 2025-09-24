import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/snackbar_helper/snackbar_helper.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../components/action_button/action_button.dart';
import '../../../components/custom_text_field/custom_text_field.dart';
import '../../../components/input_card_container/input_card_container.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static final String routeName = '/forgot-password-screen';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forgotPasswordController = Get.find<ForgotPasswordController>();
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.08),
                    Text(
                      AppStrings.forgotPasswordHeader,
                      style: textTheme.titleLarge,
                    ),
                    SizedBox(height: size.height * 0.025),
                    Text(
                      AppStrings.forgotPasswordDescription,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    InputCardContainer(
                      minHeight: size.height * 0.08,
                      children: [
                        CustomTextField(
                          controller: forgotPasswordController.emailController,
                          labelText: AppStrings.email,
                        ),
                      ],
                    ),
                    const Spacer(),
                    ActionButton(
                      title: AppStrings.getVerificationCode,
                      onPressed: () {
                        final email =
                            forgotPasswordController.emailController.text
                                .trim();
                        if (email.isNotEmpty) {
                          forgotPasswordController.sendOtpForPasswordReset(
                            email,
                          );
                        } else {
                          SnackbarHelper.show(
                            message: AppStrings.emailRequired,
                            isSuccess: false,
                            backgroundColor: AppColors.red,
                          );
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
