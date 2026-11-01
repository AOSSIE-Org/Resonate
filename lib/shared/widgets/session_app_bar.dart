import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SessionAppBar extends StatelessWidget {
  const SessionAppBar({
    super.key,
    this.icon = Icons.keyboard_arrow_down,
    this.onPressed,
  });

  final IconData icon;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(icon, size: UiSizes.size_30),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}
