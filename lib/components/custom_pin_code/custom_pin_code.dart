import 'package:flutter/material.dart';
import 'package:foodieland/features/auth/controllers/otp_verify_controller.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCode extends StatelessWidget {
  const CustomPinCode({
    super.key,
    required this.pinController,
    required this.email,
    required this.isSignUp,
  });

  final TextEditingController pinController;
  final String email;
  final bool isSignUp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: PinCodeTextField(
        controller: pinController,
        length: 6, // Ensuring exactly 6 digits are entered
        obscureText: false,
        animationType: AnimationType.fade,
        animationDuration: Duration(milliseconds: 300),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        enableActiveFill: true,
        keyboardType: TextInputType.phone, // Ensuring numbers only
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          activeColor: Colors.grey.shade200,
          inactiveColor: Colors.grey.shade200,
          selectedColor: Colors.grey.shade200,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,
          fieldWidth: 50, // Adjusted width for each field
          fieldHeight: 58, // Adjusted height for each field
        ),
        appContext: context,
        validator: (String? value) {
          if (value == null || value.length != 6) {
            return 'Enter a 6-digit OTP';
          }
          return null; // OTP is valid
        },
        onCompleted: (String pin) {
          final otpController = Get.find<OtpVerifyController>();
          otpController.verifyOtp(pin, email, isSignUp: isSignUp);
        },
        onChanged: (String value) {
          // Optionally handle input changes
        },
      ),
    );
  }
}
