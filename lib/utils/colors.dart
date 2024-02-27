import 'package:flutter/material.dart';

//AppColor predefines various colors which are used in resonte
//Hex values are specified for every color.
class AppColor {
  static const Color yellowColor = Color(0xffFDD51F);
  static const Color greenColor = Color(0xff44AA32);
  static const Color redColor = Colors.red;
  static Color greyShadeColor = Colors.grey.shade300;
  static const Color bgBlackColor = Color(0xff19191B);
  //MaterialColor allows the creation of various shades of a color.
  static const MaterialColor yellowMaterialColor = MaterialColor(
    //hex code for color
    0xffFDD51F,
    //map of shades of color
    <int, Color>{
      200: yellowColor,
    },
  );
  //flutter provides LinearGradient that allows the use of gradients in flutter apps
  static const LinearGradient gradientBg = LinearGradient(colors: [
    Colors.amber,
    AppColor.yellowColor,
  ]);
}
