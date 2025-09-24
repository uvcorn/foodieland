import 'package:flutter/material.dart';

class CustomBlogField extends StatelessWidget {
  const CustomBlogField({
    super.key,
    required this.blogController,
    required this.title,
    this.fontSize,
  });

  final TextEditingController blogController;
  final String title;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: blogController,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        border: const OutlineInputBorder(),
        // Default border
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2,
          ), // Normal state
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ), // Focused state
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ), // Validation error
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }
}
