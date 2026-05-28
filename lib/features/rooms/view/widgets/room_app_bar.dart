import 'package:flutter/material.dart';

class RoomAppBar extends StatelessWidget {
  const RoomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 36,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
