import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future<dynamic> LoadingWidget() {
  return Get.dialog(
      Center(
        child: LoadingAnimationWidget.threeRotatingDots(
            color: Colors.amber, size: Get.pixelRatio * 20),
      ),
      barrierDismissible: false,
      name: "Loading Dialog");
}