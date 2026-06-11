import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

// Bottom control bar shared by the friend call and pair chat pages.
class CallControlPanel extends StatelessWidget {
  const CallControlPanel({super.key, required this.buttons});

  final List<CallControlButton> buttons;

  // Background for buttons that are toggled off / neutral: they sit on the
  // primary panel in light mode and on the dark container in dark mode.
  static Color inactiveButtonColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return scheme.brightness == Brightness.light
        ? scheme.onPrimary.withValues(alpha: 0.5)
        : scheme.onSurface.withValues(alpha: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
      color: scheme.brightness == Brightness.light
          ? scheme.primary
          : scheme.surfaceContainerHighest,
      height: UiSizes.height_131,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }
}

class CallControlButton extends StatelessWidget {
  const CallControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.heroTag,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: UiSizes.height_56,
          width: UiSizes.width_56,
          child: FloatingActionButton(
            elevation: 0,
            heroTag: heroTag,
            onPressed: onPressed,
            backgroundColor: backgroundColor,
            child: Icon(icon, size: UiSizes.size_24),
          ),
        ),
        SizedBox(height: UiSizes.height_4),
        Text(label, style: TextStyle(fontSize: UiSizes.height_14)),
      ],
    );
  }
}
