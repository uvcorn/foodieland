import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final VoidCallback? onToggleObscureText;
  final int textFieldLines;
  final bool enableValidation; // For password validation
  final bool? textFieldEditEnable;
  final TextEditingController?
  confirmPasswordController; // For confirm password
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onToggleObscureText,
    this.enableValidation = false,
    this.confirmPasswordController,
    this.textFieldLines = 1,
    this.validator, this.textFieldEditEnable,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: TextFormField(
        minLines: textFieldLines,
        maxLines: textFieldLines == 1 ? 1 : null,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        validator: validator,
        enabled: textFieldEditEnable ?? true,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: textTheme.labelSmall,
          border: InputBorder.none,
          suffixIcon:
              onToggleObscureText != null
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onToggleObscureText,
                  )
                  : null,
        ),
      ),
    );
  }
}
