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
        fontSize: UiSizes.size_14,
        overflow: TextOverflow.ellipsis,
      ),
      radius: UiSizes.size_15,
      actions: [
        ElevatedButton(
          onPressed: onFirstBtnPressed,
          child: Text(firstBtnText),
        ),
        ElevatedButton(
          onPressed: onSecondBtnPressed,
          child: Text(secondBtnText),
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
