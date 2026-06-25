import 'package:flutter/material.dart';

/// Centralized color palette for the entire app.
class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF3949AB);       // Indigo 600
  static const Color primaryLight = Color(0xFF5C6BC0);  // Indigo 400
  static const Color primaryDark = Color(0xFF283593);   // Indigo 800

  // Accent / Secondary
  static const Color accent = Color(0xFF00897B);        // Teal 600
  static const Color accentLight = Color(0xFF26A69A);   // Teal 400

  // Status
  static const Color success = Color(0xFF43A047);       // Green 600
  static const Color warning = Color(0xFFFB8C00);       // Orange 600
  static const Color error = Color(0xFFE53935);         // Red 600

  // Surface / Background
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color cardFill = Colors.white;

  // Text
  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFF212121);
  static const Color onSurfaceLight = Color(0xFF757575);

  // Misc
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shimmer = Color(0xFFEEEEEE);
}

/// App-wide ThemeData built from [AppColors].
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: AppColors.onPrimary,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.cardFill,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        prefixIconColor: AppColors.primaryLight,
        labelStyle: const TextStyle(color: AppColors.onSurfaceLight),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dividerColor: AppColors.divider,
    );
  }
}
