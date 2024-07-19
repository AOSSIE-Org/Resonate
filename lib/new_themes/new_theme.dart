import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/models/themes_model.dart';

import '../utils/ui_sizes.dart';

class NewTheme {
  static ThemeData setLightTheme(ThemeModel theme) {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,
        primary: theme.primaryColor,
        onPrimary: theme.onPrimaryColor,
        secondary: theme.secondaryColor,
        onSecondary: theme.onSecondaryColor,
        surface: theme.surfaceColor,
        onSurface: theme.onSurfaceColor,
        surfaceTint: Colors.transparent,
        background: theme.backgroundColor,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.backgroundColor
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          // Flutter uses this TextStyle in InputFormField for styling user input text
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          color: Colors.black54
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.black54,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.onPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: UiSizes.height_10),
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
          borderSide: BorderSide(
            color: theme.primaryColor,
          ),
        ),
        fillColor: theme.secondaryColor,
        filled: true,
        hintStyle: TextStyle(
          color: theme.onSecondaryColor,
        ),
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
      colorScheme: ColorScheme.dark(
        brightness: Brightness.dark,
        primary: theme.primaryColor,
        onPrimary: theme.onPrimaryColor,
        secondary: theme.secondaryColor,
        onSecondary: theme.onSecondaryColor,
        surface: theme.surfaceColor,
        onSurface: theme.onSurfaceColor,
        surfaceTint: Colors.transparent,
        background: theme.backgroundColor,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.backgroundColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          // Flutter uses this TextStyle in InputFormField for styling user input text
          color: Colors.white,
        ),
        titleMedium: TextStyle(
            color: Colors.white54
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white54,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.onPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: UiSizes.height_10),
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
          borderSide: BorderSide(
            color: theme.primaryColor,
          ),
        ),
        fillColor: theme.secondaryColor,
        filled: true,
        hintStyle: TextStyle(
          color: theme.onSecondaryColor,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
      ),
    );
  }
}
