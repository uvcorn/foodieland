import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_strings/app_strings.dart';
import '../../../components/action_button/action_button.dart';
import '../../../components/custom_checkbox/custom_checkbox.dart';
import '../../../components/custom_pin_code/custom_pin_code.dart';
import '../controllers/otp_verify_controller.dart';

class OtpVerifyScreen extends StatelessWidget {
  final String email;
  final bool isSignUp; // To differentiate between sign-up and forgot password

  const OtpVerifyScreen({super.key, required this.email, this.isSignUp = true});

  @override
  Widget build(BuildContext context) {
    final otpController = Get.find<OtpVerifyController>();
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.08),
                    Text(
                      AppStrings.enterVerificationCode,
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: size.height * 0.04),
                    CustomPinCode(
                      pinController: otpController.otpTEController,
                      email: email,
                      isSignUp: isSignUp,
                    ),
                    SizedBox(height: size.height * 0.045),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomCheckbox(
                          showCheckbox: false,
                          leadingText: AppStrings.noCodeReceived,
                          leadingTextStyle: textTheme.bodySmall?.copyWith(
                            color: AppColors.black,
                          ),
                          clickableText: AppStrings.resendCode,
                          centerAlignment: true,
                          clickableTextStyle: textTheme.bodyMedium,
                          useSpaceBetweenAlignment: false,
                          onLinkTap: () {
                            otpController.resendSignUpOtp(email);
                            otpController.otpTEController.clear();
                          },
                        ),
                        SizedBox(height: size.height * 0.06),
                        ActionButton(
                          title: AppStrings.verifyButton,
                          onPressed: () {
                            final otp = otpController.otpTEController.text;
                            otpController.verifyOtp(
                              otp,
                              email,
                              isSignUp: isSignUp,
                            );
                          },
                        ),
                      ],
                    ),
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
