import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future<void> loadingDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => Center(
      child: LoadingAnimationWidget.threeRotatingDots(
        color: Theme.of(context).colorScheme.primary,
        size: MediaQuery.of(context).devicePixelRatio * 20,
      ),
    ),
  );
}
