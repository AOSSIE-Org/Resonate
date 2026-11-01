import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/utils/ui_sizes.dart';


class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.height, this.width});
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height ?? UiSizes.height_200,
        width: width ?? UiSizes.width_200,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotate,
          colors: [Theme.of(context).colorScheme.primary],
        ),
      ),
    );
  }
}
