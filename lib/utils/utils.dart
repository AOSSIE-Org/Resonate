import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AppUtils {
  AppUtils._();

  static void showDialog({
    required String title,
    required String middleText,
    String firstBtnText = "Confirm",
    String secondBtnText = "Cancel",
    required VoidCallback onFirstBtnPressed,
    required VoidCallback onSecondBtnPressed,
    TextStyle? firstBtnTextStyle,
    TextStyle? secondBtnTextStyle,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: middleText,
      barrierDismissible: false,
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: UiSizes.size_16,
      ),
      middleTextStyle: TextStyle(
        fontSize: UiSizes.size_12,
        overflow: TextOverflow.ellipsis,
      ),
      radius: UiSizes.size_20,
      titlePadding: EdgeInsets.only(top: UiSizes.size_25),
      contentPadding: EdgeInsets.symmetric(
          horizontal: UiSizes.size_20, vertical: UiSizes.size_20),
      actions: [
        ElevatedButton(
          onPressed: onFirstBtnPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            firstBtnText,
            style: TextStyle(
              color: const Color(0xFF725001),
              fontSize: UiSizes.size_14,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onSecondBtnPressed,
          style: ElevatedButton.styleFrom(
            textStyle: secondBtnTextStyle,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            secondBtnText,
            style: TextStyle(
              color: const Color(0xFF725001),
              fontSize: UiSizes.size_14,
            ),
          ),
        ),
      ],
    );
  }

  static void showBlurredLoaderDialog() {
    Get.dialog(
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Center(
            child: LoadingAnimationWidget.threeRotatingDots(
              color: Colors.amber,
              size: Get.pixelRatio * 20,
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
