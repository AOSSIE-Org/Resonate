import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class Themes {
  static final lightTheme = ThemeData(
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,

    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarHeight: UiSizes.size_56,
      titleTextStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
    ),

    // new
    primarySwatch: Colors.amber,
    brightness: Brightness.light,

    iconTheme: Get.theme.iconTheme.copyWith(
      size: UiSizes.size_24,
      color: Colors.amber,
    ),

    inputDecorationTheme: InputDecorationTheme(
      iconColor: Colors.amber,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: UiSizes.width_2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        // borderSide: BorderSide(color: Colors.white60),
      ),
      suffixIconColor: Colors.amber,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiSizes.size_12), // <-- Radius
          // side: BorderSide(width: UiSizes.width_1, color: Colors.black),
        ),
        minimumSize: Size.fromHeight(UiSizes.height_45), // NEW
      ),
    ),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColor.bgBlackColor,
    colorScheme: const ColorScheme.dark(
      primary: Colors.amber,
      secondary: Colors.amber,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      surface: Color.fromRGBO(17, 17, 20, 1),
      onSurface: Colors.amber,
      error: Color(0xFDFF0000),
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.amber,
      toolbarHeight: UiSizes.size_56,
      elevation: 0,
      titleTextStyle: const TextStyle(
          color: Colors.amber, fontWeight: FontWeight.w500, fontSize: 24),
    ),
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
    iconTheme: Get.theme.iconTheme.copyWith(
      size: UiSizes.size_24,
      color: AppColor.yellowColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      iconColor: AppColor.yellowColor,
      focusedBorder: UnderlineInputBorder(
        borderSide:
            BorderSide(color: AppColor.yellowColor, width: UiSizes.width_2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white60),
      ),
      suffixIconColor: AppColor.yellowColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.yellowColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiSizes.size_12), // <-- Radius
            side: BorderSide(width: UiSizes.width_1, color: Colors.grey[800]!)),
        minimumSize: Size.fromHeight(UiSizes.height_45), // NEW
      ),
    ),
  );
}
