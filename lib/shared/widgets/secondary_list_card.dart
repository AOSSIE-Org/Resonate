import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SecondaryListCard extends StatelessWidget {
  const SecondaryListCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiSizes.width_10),
        color: Theme.of(context).colorScheme.secondary,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: UiSizes.width_16,
        vertical: UiSizes.height_8,
      ),
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
      child: child,
    );
  }
}
