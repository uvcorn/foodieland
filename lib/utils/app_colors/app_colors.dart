// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  static Color themeColor = const Color(0xFF008080);
  static const Color primary = Color(0xFF009688);
  static const Color secPrimary = Color(0xFF876424);
  // Explicitly named colors
  static const Color greenish = Color(0xFF10B981); // (Greenish/Teal)
  static const Color red = Color(0xFFEF4444);
  static const Color lightBlue = Color(0xFFDEE9FB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color mediumGray = Color(0xFF9E9E9E);

  static const Color lightGray = Color(0xFFF4F4F4);

  // Border specific grays - keeping distinct names
  static const Color borderGray = Color(0xFFE0E0E0);
  static MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }
}
