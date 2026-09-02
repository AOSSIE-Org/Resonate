import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/features/theme/model/achievement_colors.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';
import 'package:resonate/features/theme/model/theme_model.dart';
import 'package:resonate/utils/ui_sizes.dart';

class ThemeModes {
  static ThemeData setLightTheme(ThemeModel theme) {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: theme.surfaceColor,
      extensions: const [ActivityStatusColors.light, AchievementColors.light],
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: theme.primaryColor,
        onPrimary: theme.onPrimaryColor,
        secondary: theme.secondaryColor,
        onSecondary: theme.onSecondaryColor,
        surface: theme.surfaceColor,
        onSurface: theme.onSurfaceColor,
        surfaceTint: Colors.transparent,
        surfaceContainerHighest: const Color.fromARGB(255, 122, 122, 122),
        onSurfaceVariant: const Color(0xFF616161),

        secondaryContainer: const Color(0xFFEEEEEE),
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.surfaceColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black54),
      ),
      dividerTheme: const DividerThemeData(color: Colors.black54),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.onPrimaryColor,
          fixedSize: const Size.fromHeight(48),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: UiSizes.size_16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.primaryColor),
          fixedSize: const Size.fromHeight(48),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: UiSizes.size_16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        fillColor: theme.secondaryColor,
        filled: true,
        prefixIconColor: theme.onSecondaryColor,
        hintStyle: TextStyle(color: theme.onSecondaryColor),
        labelStyle: TextStyle(color: theme.onSecondaryColor),
        floatingLabelStyle: TextStyle(color: theme.primaryColor),
        contentPadding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
      ),
    );
  }

  static ThemeData setDarkTheme(ThemeModel theme) {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: theme.surfaceColor,
      extensions: const [ActivityStatusColors.dark, AchievementColors.dark],
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: theme.primaryColor,
        onPrimary: theme.onPrimaryColor,
        secondary: theme.secondaryColor,
        onSecondary: theme.onSecondaryColor,
        surface: theme.surfaceColor,
        onSurface: theme.onSurfaceColor,
        surfaceTint: Colors.transparent,

        surfaceContainerHighest: const Color(0xFF424242),
        onSurfaceVariant: const Color(0xFFBDBDBD),

        secondaryContainer: const Color(0xFF616161),
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.surfaceColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white54),
      ),
      dividerTheme: const DividerThemeData(color: Colors.white54),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.onPrimaryColor,
          fixedSize: const Size.fromHeight(48),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: UiSizes.size_16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.primaryColor),
          fixedSize: const Size.fromHeight(48),
          textStyle: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: UiSizes.size_16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        fillColor: theme.secondaryColor,
        filled: true,
        prefixIconColor: theme.onSecondaryColor,
        hintStyle: TextStyle(color: theme.onSecondaryColor),
        labelStyle: TextStyle(color: theme.onSecondaryColor),
        floatingLabelStyle: TextStyle(color: theme.primaryColor),
        contentPadding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
      ),
    );
  }
}
