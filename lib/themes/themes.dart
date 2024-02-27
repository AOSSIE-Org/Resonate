//import required packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

//class Themes containes ThemeData for light and dark modes
class Themes {
  //lightTheme configuration
  static final lightTheme = ThemeData(
    //Use poppins font provided by GoogleFonts class defined in google_fonts package
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
    //ColorScheme for light theme
    colorScheme: const ColorScheme.light(
      primary: Colors.amber,
      onPrimary: Colors.white,
      error: Color(0xFDFF0000),
      onError: Colors.white,
    ),
    //Configure AppBarTheme
    appBarTheme: AppBarTheme(
      elevation: 0,
      //UiSizes is defined in lib\utils\ui_sizes.dart
      toolbarHeight: UiSizes.size_56,
      titleTextStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
    ),

    // new
    //define primary swatch for the app.
    primarySwatch: Colors.amber,
    brightness: Brightness.light,
    //use Get.theme to obtain device's iconTheme
    //CopyWith is used to modify only those values that are explictly specified, i.e size and color(in this case)
    iconTheme: Get.theme.iconTheme.copyWith(
      size: UiSizes.size_24,
      color: Colors.amber,
    ),
    //use InputDecorationTheme to modify decoration of any TextInputField
    inputDecorationTheme: InputDecorationTheme(
      iconColor: Colors.amber,
      //Use UnderlineInputBorder for text input fields.
      //focusedBorder theme will be applied when a text field is in focus i.e when a text fiels is selected
      focusedBorder: UnderlineInputBorder(
        //Customize the border(appearing below the text input field) of UnderlineInputBorder with borderSide property
        borderSide: BorderSide(color: Colors.amber, width: UiSizes.width_2),
      ),
      //enabledBorder theme is used in any text input field that is enabled.
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        // borderSide: BorderSide(color: Colors.white60),
      ),
      //the color of suffixIcon (icon at the beginning of text input field)
      suffixIconColor: Colors.amber,
    ),
    //Theme used by elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      //use styleForm to customize various aspects of elevated button
      //using styleForm allows the customizatio of only those properties which are modified.
      //Everything else remains the same.
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        elevation: 2,
        foregroundColor: Colors.black,
        //use RoundedRectangularBorder shape. (rounds the edges of a normal rectangle)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiSizes.size_12), // <-- Radius
          // side: BorderSide(width: UiSizes.width_1, color: Colors.black),
        ),
        minimumSize: Size.fromHeight(UiSizes.height_45), // NEW
      ),
    ),
  );
  //darkTheme configuration
  static final darkTheme = ThemeData(
    //set the scaffold background color to bgBlackColor
    //bgBlackColor is defined in AppColor present in lib\utils\colors.dart
    scaffoldBackgroundColor: AppColor.bgBlackColor,
    //Use dark ColorScheme
    colorScheme: const ColorScheme.dark(
      //color values for used in darkTheme
      primary: Colors.amber,
      secondary: Colors.amber,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      surface: Color.fromRGBO(17, 17, 20, 1),
      onSurface: Colors.amber,
      error: Color(0xFDFF0000),
      onError: Colors.white,
    ),
    //AppBarTheme for darkMode
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
    //InputDecorationTheme for darkTheme
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
    //Elevated Button theme for darkTheme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.yellowColor,
        foregroundColor: Colors.black,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiSizes.size_12), // <-- Radius
            side: BorderSide(width: UiSizes.width_1, color: Colors.grey[800]!)),
        minimumSize: Size.fromHeight(UiSizes.height_45), // NEW
      ),
    ),
  );
}
