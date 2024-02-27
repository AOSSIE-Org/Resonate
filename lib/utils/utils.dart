import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AppUtils {
  AppUtils._();
  //showDialog function that uses Get.defaultDialog to displplay a dialog on screen.

  //showDialog defines various parameters that which allows specifying the
  //title,middleText, onFirstBtnPressed, onSecondBtnPressed,firstBtnTextStyle, secondBtnTextStyle
  //whenever showDialog is called.

  //firstBtnText and secondBtnText are initialized with default values of "Confirm" & "Cancel" respectively
  //These values can be changes by using firstBtnText & secondBtnText and specifying different vaalues.
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
    //NOTE: get state management provides some handy ways to use certain widget without using context.
    //Get.defaultDialog displays a dialog on screen which is similar to flutters showDialog.
    Get.defaultDialog(
      //customize the dialog
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
        horizontal: UiSizes.size_20,
        vertical: UiSizes.size_20,
      ),
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

  //show showBlurredLoaderDialog function that diaplays a dialog whenever the function is called.
  static void showBlurredLoaderDialog() {
    //Get.dialog is used to display a dialog
    Get.dialog(
      //use BackdropFiler (a widget provided by flutter) to create a blurred effect using filter property.
      BackdropFilter(
        //entire screen except the child placed insied BackdropFilter will be blurred
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          //display three rotating dots using LoadingAnimationWidget provided by loading_animation_widget package
          child: LoadingAnimationWidget.threeRotatingDots(
            color: Colors.amber,
            size: Get.pixelRatio * 20,
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
