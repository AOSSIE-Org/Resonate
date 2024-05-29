import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class Themes {
  static ThemeData getLightTheme(Color primaryColor) {
    return ThemeData(
      fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.black,
        error: const Color(0xFDFF0000),
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        toolbarHeight: UiSizes.size_56,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
      ),

      // new
      //  primarySwatch: primaryColor,
      brightness: Brightness.light,

      iconTheme: Get.theme.iconTheme.copyWith(
        size: UiSizes.size_24,
        color: primaryColor,
      ),

      inputDecorationTheme: InputDecorationTheme(
        iconColor: primaryColor,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: UiSizes.width_2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
          // borderSide: BorderSide(color: Colors.white60),
        ),
        suffixIconColor: primaryColor,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 2,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiSizes.size_12), // <-- Radius
            // side: BorderSide(width: UiSizes.width_1, color: Colors.black),
          ),
          minimumSize: Size.fromHeight(UiSizes.height_45), // NEW
        ),
      ),
    );
  }

  static ThemeData getDarkTheme(Color primaryColor) {
    return ThemeData(
      scaffoldBackgroundColor: AppColor.bgBlackColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        onPrimary: const Color(0xFFF4F4F4),
        onSecondary: Colors.black,
        surface: const Color.fromRGBO(17, 17, 20, 1),
        onSurface: primaryColor,
        error: const Color(0xFDFF0000),
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        foregroundColor: primaryColor,
        toolbarHeight: UiSizes.size_56,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: primaryColor, fontWeight: FontWeight.w500, fontSize: 24),
      ),
      fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
      iconTheme: Get.theme.iconTheme.copyWith(
        size: UiSizes.size_24,
        color: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        iconColor: primaryColor,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: UiSizes.width_2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white60),
        ),
        suffixIconColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(UiSizes.size_12), // <-- Radius
              side:
                  BorderSide(width: UiSizes.width_1, color: Colors.grey[800]!)),
          minimumSize: Size.fromHeight(UiSizes.height_45), // NEW
        ),
      ),
    );
  }
}
