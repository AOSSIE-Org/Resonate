import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/ui_sizes.dart';

Future<Widget?> newLoadingDialog(BuildContext context) {

  return Get.dialog<Widget>(
      Center(
        child: LoadingAnimationWidget.threeRotatingDots(
            color: Theme.of(context).colorScheme.primary,
            size: UiSizes.width_40,
        ),
      ),
      barrierDismissible: false,
      name: "Loading Dialog",
  );

}