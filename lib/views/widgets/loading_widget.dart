import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/themes/theme_controller.dart';

Future<dynamic> loadingWidget() {
  final ThemeController themeController = Get.find<ThemeController>();
  return Get.dialog(
      Center(
        child: LoadingAnimationWidget.threeRotatingDots(
            color: themeController.primaryColor.value,
            size: Get.pixelRatio * 20),
      ),
      barrierDismissible: false,
      name: "Loading Dialog");
}
