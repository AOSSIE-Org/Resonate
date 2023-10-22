import 'package:flutter/material.dart';

class AppColor {
  static const Color yellowColor = Color(0xffFDD51F);
  static const Color greenColor = Color(0xff44AA32);
  static const Color redColor = Colors.red;
  static Color greyShadeColor = Colors.grey.shade300;
  static const Color bgBlackColor = Color(0xff19191B);
  static const MaterialColor yellowMaterialColor = MaterialColor(
    0xffFDD51F,
    <int, Color>{
      200: yellowColor,
    },
  );

  static const LinearGradient gradientBg = LinearGradient(colors: [
    Colors.amber,
    AppColor.yellowColor,
  ]);
}
