import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        tertiary: AppColors.support,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),

      scaffoldBackgroundColor: AppColors.background,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        centerTitle: true,
        toolbarHeight: 80,
        titleTextStyle: TextStyle(
          color: AppColors.onPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          minimumSize: const Size(200, 72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent, width: 3),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          minimumSize: const Size(180, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(120, 56),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 6,
        iconSize: 36,
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: const TextStyle(color: AppColors.primary, fontSize: 20),
        hintStyle: TextStyle(color: AppColors.grey500, fontSize: 18),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(16),
        shadowColor: AppColors.grey300,
      ),

      // Text Styles
      textTheme: const TextTheme(
        // Headlines
        headlineLarge: TextStyle(
          color: AppColors.primary,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          color: AppColors.primary,
          fontSize: 40,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          color: AppColors.primary,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),

        // Titles
        titleLarge: TextStyle(
          color: AppColors.onBackground,
          fontSize: 28,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          color: AppColors.onBackground,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          color: AppColors.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),

        // Body Text
        bodyLarge: TextStyle(
          color: AppColors.onBackground,
          fontSize: 22,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.onBackground,
          fontSize: 20,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          color: AppColors.grey700,
          fontSize: 18,
          height: 1.4,
        ),

        // Labels
        labelLarge: TextStyle(
          color: AppColors.support,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: AppColors.grey700,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: AppColors.grey500,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Navigation
      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.support,
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: AppColors.accent,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface,
        elevation: 4,
      ),

      // Feedback Components
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: const TextStyle(color: AppColors.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.accent,
        labelStyle: const TextStyle(color: AppColors.onBackground),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return lightTheme;
  }
}
