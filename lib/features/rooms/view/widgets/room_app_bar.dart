import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RoomAppBar extends StatelessWidget {
  const RoomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: UiSizes.size_35,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
