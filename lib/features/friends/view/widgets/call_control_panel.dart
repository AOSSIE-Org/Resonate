import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';


class CallControlPanel extends StatelessWidget {
  const CallControlPanel({
    super.key,
    required this.isMicOn,
    required this.isLoudSpeakerOn,
    required this.onToggleMic,
    required this.onToggleLoudSpeaker,
    required this.onAudioSettings,
    required this.onEnd,
  });

  final bool isMicOn;
  final bool isLoudSpeakerOn;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleLoudSpeaker;
  final VoidCallback onAudioSettings;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inactive = scheme.surfaceContainerHighest;
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
            // Highlighted while the mic is live.
            _CallControlButton(
              id: 'mic',
              icon: isMicOn ? Icons.mic : Icons.mic_off,
              onPressed: onToggleMic,
              backgroundColor: isMicOn ? scheme.primary : inactive,
              foregroundColor: isMicOn ? scheme.onPrimary : scheme.onSurface,
            ),
            _CallControlButton(
              id: 'speaker',
              icon: Icons.volume_up,
              onPressed: onToggleLoudSpeaker,
              backgroundColor: isLoudSpeakerOn ? scheme.primary : inactive,
              foregroundColor: isLoudSpeakerOn
                  ? scheme.onPrimary
                  : scheme.onSurface,
            ),
            _CallControlButton(
              id: 'audio-settings',
              icon: Icons.settings_voice,
              onPressed: onAudioSettings,
              backgroundColor: inactive,
              foregroundColor: scheme.onSurface,
            ),
            _CallControlButton(
              id: 'end-chat',
              icon: Icons.call_end,
              onPressed: onEnd,
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            ),
          ],
        ),
      ),
    );
  }
}

class _CallControlButton extends StatelessWidget {
  const _CallControlButton({
    required this.id,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String id;

  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_5),
      child: Material(
        key: ValueKey('call-control-$id'),
        color: backgroundColor,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: UiSizes.width_56,
            height: UiSizes.width_56,
            child: Center(
              child: Icon(icon, size: UiSizes.size_26, color: foregroundColor),
            ),
          ),
        ),
      ),
    );
  }
}
