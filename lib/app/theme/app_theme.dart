import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final textTheme = GoogleFonts.manropeTextTheme().copyWith(
      headlineSmall: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: AppColors.white,
      ),
      titleLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: AppColors.white,
      ),
      titleMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppColors.white,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: AppColors.white,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColors.silver,
      ),
      labelSmall: GoogleFonts.manrope(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.silver,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.nearBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.green,
        secondary: AppColors.green,
        surface: AppColors.nearBlack,
        error: AppColors.negativeRed,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.nearBlack,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: AppColors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.midDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: GoogleFonts.manrope(
          color: AppColors.silver,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.manrope(
          color: AppColors.silver,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        prefixIconColor: AppColors.silver,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500),
          borderSide: const BorderSide(color: AppColors.green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500),
          borderSide: const BorderSide(color: AppColors.negativeRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(500),
          borderSide: const BorderSide(color: AppColors.negativeRed, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.nearBlack,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(500),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.white,
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(500),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCard,
        contentTextStyle: GoogleFonts.manrope(
          color: AppColors.white,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.green;
          }
          return AppColors.silver;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.green.withValues(alpha: 0.3);
          }
          return AppColors.borderGray;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.green,
        inactiveTrackColor: AppColors.borderGray,
        thumbColor: AppColors.green,
        overlayColor: AppColors.green.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.green,
        valueIndicatorTextStyle: GoogleFonts.manrope(
          color: AppColors.nearBlack,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderGray,
        thickness: 0.5,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.green,
      ),
    );
  }
}
