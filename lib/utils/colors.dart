import 'package:flutter/material.dart';

class AppColor {
  static const Color yellowColor = Color(0xffFDD51F);
  static const Color greenColor = Color(0xff44AA32);
  static const Color orangeColor = Colors.orange;
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
  static const Map<String, Color> categoryColorList = {
    "drama": Color.fromARGB(255, 237, 29, 154),
    "horror": Color.fromARGB(255, 21, 178, 136),
    "comedy": Color.fromARGB(255, 142, 16, 238),
    "thriller": Color.fromARGB(255, 38, 83, 215),
    "romance": Color.fromARGB(255, 140, 204, 37),
    "spiritual": Color.fromARGB(255, 218, 83, 83),
  };
}
