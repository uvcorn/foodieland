import 'package:flutter/material.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../custom_text/custom_text.dart';

class CustomDropdownMenu extends StatelessWidget {
  final String? selectedValue;
  final List<String> options;
  final String hint;
  final ValueChanged<String> onSelected;

  // Optional styling
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final Color hintTextColor;
  // Style switches
  final bool isUnderlineStyle;
  final bool isCircularBorderStyle;

  // Border customizations
  final Color underlineColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;

  const CustomDropdownMenu({
    super.key,
    required this.options,
    required this.hint,
    this.hintTextColor = AppColors.black,
    required this.onSelected,
    this.selectedValue,
    this.height = 44,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.black,
    this.fontSize = 14,
    this.isUnderlineStyle = false,
    this.isCircularBorderStyle = true,
    this.underlineColor = AppColors.black,
    this.borderColor = AppColors.black,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final boxDecoration =
        isCircularBorderStyle
            ? BoxDecoration(
              color: backgroundColor,
              // border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            )
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PopupMenuButton<String>(
          onSelected: onSelected,
          position: PopupMenuPosition.under,
          offset: const Offset(1, 0),
          itemBuilder:
              (BuildContext context) =>
                  options
                      .map(
                        (option) => PopupMenuItem<String>(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
          color: backgroundColor,
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: boxDecoration,
            color: isCircularBorderStyle ? null : backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: selectedValue ?? hint,
                  fontSize: fontSize,
                  color: selectedValue == null ? hintTextColor : textColor,
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),

        // Only show underline if enabled and circular border is not
        if (isUnderlineStyle && !isCircularBorderStyle)
          Container(height: 1, color: underlineColor),
      ],
    );
  }
}
