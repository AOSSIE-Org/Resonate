
import 'package:flutter/material.dart';

class AppColor{
  static const Color yellowColor = Color(0xffFDD51F);
  static const Color greenColor = Color(0xff44AA32);
  static const Color bgBlackColor = Color(0xff19191B);

  static const LinearGradient gradientBg = LinearGradient(colors: [
    Colors.amber,
    AppColor.yellowColor,
  ]);
}