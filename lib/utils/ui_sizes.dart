import 'package:get/get.dart';

class UiSizes {
  // Height expressions
  static var height_1 = Get.height * 0.0012;
  static var height_10 = Get.height * 0.012;
  static var height_15 = Get.height * 0.018;
  static var height_19_7 = Get.height * 0.024;
  static var height_29_6 = Get.height * 0.036;
  static var height_65_7 = Get.height * 0.08;
  static var height_180 = Get.height * 0.219;
  static var height_780 = Get.height * 0.95;

  // Width expressions
  static var width_5 = 0.012 * Get.width;
  static var width_10 = 0.024 * Get.width;
  static var width_20 = 0.0486 * Get.width;
  static var width_29_6 = 0.072 * Get.width;
  static var width_180 = 0.437 * Get.width;

  // Size expressions
  static var size_14 = 0.0085 * Get.height + 0.017 * Get.width;
  static var size_17 = 0.01 * Get.height + 0.021 * Get.width;
  static var size_19 = 0.024 * Get.width + 0.012 * Get.height;
  static var size_23 = 0.014 * Get.height + 0.029 * Get.width;
  static var size_24_6 = 0.015 * Get.height + 0.03 * Get.width;
  static var size_40 = 0.024 * Get.height + 0.048 * Get.width;
}
