import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/models/themes_model.dart';

class NewTheme {

  static ThemeData getTheme(ThemeModel theme) {
    return ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme.light(
        brightness: Brightness.light,

        primary: theme.primaryColor,
        onPrimary: theme.onPrimaryColor,
        background: theme.backgroundColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: theme.backgroundColor,
        foregroundColor: theme.primaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black54,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.black54,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.onPrimaryColor,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.onPrimaryColor
        ),
      ),
    );
  }





  // static ThemeData classicDarkTheme = ThemeData(
  //
  //
  //   fontFamily: GoogleFonts.poppins().fontFamily,
  //   colorScheme: const ColorScheme.dark(
  //     brightness: Brightness.dark,
  //     primary: darkThemePrimaryColor,
  //     onPrimary: darkThemeOnPrimaryColor,
  //     background: darkThemeBackgroundColor,
  //   ),
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: darkThemeBackgroundColor,
  //     foregroundColor: darkThemePrimaryColor,
  //   ),
  //   textTheme: const TextTheme(
  //     bodyLarge: TextStyle(
  //       color: Colors.white54,
  //     ),
  //   ),
  //   dividerTheme: const DividerThemeData(
  //     color: Colors.white54,
  //   ),
  //   elevatedButtonTheme: ElevatedButtonThemeData(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: darkThemePrimaryColor,
  //       foregroundColor: darkThemeOnPrimaryColor,
  //     ),
  //   ),
  //   iconButtonTheme: IconButtonThemeData(
  //     style: IconButton.styleFrom(
  //       backgroundColor: darkThemePrimaryColor,
  //       foregroundColor: darkThemeOnPrimaryColor,
  //     ),
  //   ),
  // );

}
