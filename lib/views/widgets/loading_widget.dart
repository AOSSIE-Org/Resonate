import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

//loadingWidget is Future which displays a dialog with the help of Get.dialog
Future<dynamic> loadingWidget() {
  //dialog displays threeRotatingDots made available by loading_animation_widget package
  return Get.dialog(
      Center(
        child: LoadingAnimationWidget.threeRotatingDots(
            color: Colors.amber, size: Get.pixelRatio * 20),
      ),
      //makes dialog non-dismissible when user clicks outside the dialog.
      barrierDismissible: false,
      //name of the dialog
      name: "Loading Dialog");
}
