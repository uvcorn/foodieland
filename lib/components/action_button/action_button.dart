import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/app_colors/app_colors.dart';

enum ActionButtonType { filled, outlined, text }

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed; // Changed to nullable
  final String? icon; // SVG asset path
  final double width;
  final double height;
  final double borderRadius;
  final ActionButtonType type;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double elevation;
  final double iconTextSpacing;

  const ActionButton({
    super.key,
    required this.title,
    this.onPressed, // Removed 'required'
    this.icon,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 8,
    this.type = ActionButtonType.filled,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.elevation = 0,
    this.iconTextSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasIcon = icon != null;

    final bg =
        backgroundColor ??
        (type == ActionButtonType.filled
            ? AppColors.primary
            : Colors.transparent);
    final txtColor =
        textColor ??
        (type == ActionButtonType.filled ? AppColors.white : AppColors.primary);
    final brdColor =
        borderColor ??
        (type == ActionButtonType.outlined
            ? AppColors.primary
            : Colors.transparent);

    final iconWidget =
        hasIcon
            ? Padding(
              padding: EdgeInsets.only(left: 16, right: iconTextSpacing),
              child: SvgPicture.asset(
                icon!,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(txtColor, BlendMode.srcIn),
              ),
            )
            : const SizedBox(width: 16);

    final child = Row(
      children: [
        if (hasIcon) iconWidget,
        Expanded(
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: textTheme.bodyMedium!.copyWith(color: txtColor),
            ),
          ),
        ),
        if (hasIcon) SizedBox(width: 16 + 24 + iconTextSpacing),
      ],
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: BorderSide(color: brdColor),
    );

    final button = switch (type) {
      ActionButtonType.filled => ElevatedButton(
        onPressed: onPressed, // Now correctly accepts nullable value
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: elevation,
          padding: EdgeInsets.zero,
          shape: shape,
        ),
        child: child,
      ),
      ActionButtonType.outlined => OutlinedButton(
        onPressed: onPressed, // Now correctly accepts nullable value
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          padding: EdgeInsets.zero,
          shape: shape,
        ),
        child: child,
      ),
      ActionButtonType.text => TextButton(
        onPressed: onPressed, // Now correctly accepts nullable value
        style: TextButton.styleFrom(backgroundColor: bg, shape: shape),
        child: child,
      ),
    };

    return SizedBox(width: width, height: height, child: button);
  }
}
