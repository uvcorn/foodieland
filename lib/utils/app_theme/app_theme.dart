import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors/app_colors.dart';

class AppTheme {
  static ThemeData get lightThemeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.getMaterialColor(AppColors.themeColor),
      ),
      textTheme: _textTheme.apply(),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.secPrimary, width: 1.5),
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
        centerTitle: true,
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      // titleLarge: TextStyle(
      //   fontSize: 28,
      //   fontWeight: FontWeight.w600,
      //   letterSpacing: .4,
      // ),
      // titleMedium: TextStyle(
      //   fontSize: 24,
      //   fontWeight: FontWeight.w600,
      //   letterSpacing: .4,
      // ),
      // titleSmall: TextStyle(
      //   fontSize: 22,
      //   fontWeight: FontWeight.w600,
      //   letterSpacing: .4,
      // ),
      // headlineMedium: TextStyle(fontSize: 16, color: Colors.grey),
      headlineLarge: GoogleFonts.tiltWarp(fontSize: 48, color: AppColors.black),
      headlineMedium: GoogleFonts.tiltWarp(
        fontSize: 24,
        color: AppColors.black,
      ),
      headlineSmall: GoogleFonts.roboto(fontSize: 20, color: AppColors.black),
      titleLarge: GoogleFonts.tiltWarp(fontSize: 32, color: AppColors.black),
      titleMedium: GoogleFonts.tiltWarp(fontSize: 24, color: AppColors.black),
      titleSmall: GoogleFonts.tiltWarp(fontSize: 22, color: AppColors.black),
      bodyLarge: GoogleFonts.roboto(fontSize: 18, color: AppColors.black),
      bodyMedium: GoogleFonts.roboto(fontSize: 16, color: AppColors.black),

      bodySmall: GoogleFonts.roboto(fontSize: 14, color: AppColors.mediumGray),
      labelSmall: GoogleFonts.roboto(fontSize: 12, color: AppColors.mediumGray),
    );
  }
}
