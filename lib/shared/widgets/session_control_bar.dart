import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

enum SessionControlKind {
  leave,
  mic,
  raiseHand,
  record,
  audioDevice,
  chat,
}

class SessionControl {
  const SessionControl(this.kind, {this.active = false, this.onTap});

  final SessionControlKind kind;
  final bool active;
  final VoidCallback? onTap;
}

class SessionControlBar extends StatelessWidget {
  const SessionControlBar({super.key, required this.controls});

  final List<SessionControl> controls;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: UiSizes.height_16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_10,
          vertical: UiSizes.height_10,
        ),
        decoration: BoxDecoration(
          color: scheme.secondary,
          borderRadius: BorderRadius.circular(UiSizes.width_56),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: UiSizes.width_10,
              offset: Offset(0, UiSizes.height_2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final control in controls) _ControlDisc(control: control),
          ],
        ),
      ),
    );
  }
}

class _ControlDisc extends StatelessWidget {
  const _ControlDisc({required this.control});

  final SessionControl control;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final kind = control.kind;
    final enabled = control.onTap != null;
    final danger =
        kind == SessionControlKind.leave ||
        (kind == SessionControlKind.record && control.active);

    final Color background;
    final Color foreground;
    if (danger) {
      background = scheme.error;
      foreground = scheme.onError;
    } else if (control.active) {
      background = scheme.primary;
      foreground = scheme.onPrimary;
    } else {
      background = scheme.surfaceContainerHighest;
      foreground = enabled
          ? scheme.onSurface
          : scheme.onSurface.withValues(alpha: 0.4);
    }

    final diameter = kind == SessionControlKind.leave
        ? UiSizes.width_66
        : UiSizes.width_56;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_5),
      child: Material(
        key: ValueKey('session-control-${kind.name}'),
        color: background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: control.onTap,
          child: SizedBox(
            width: diameter,
            height: diameter,
            child: Center(
              child: Icon(
                _iconFor(kind, control.active),
                size: UiSizes.size_26,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(SessionControlKind kind, bool active) =>
      switch (kind) {
        SessionControlKind.leave => Icons.call_end,
        SessionControlKind.mic => active ? Icons.mic : Icons.mic_off,
        SessionControlKind.raiseHand =>
          active ? Icons.back_hand : Icons.back_hand_outlined,
        SessionControlKind.record =>
          active ? Icons.radio_button_checked : Icons.fiber_manual_record,
        SessionControlKind.audioDevice => Icons.volume_up,
        SessionControlKind.chat => Icons.chat,
      };
}
