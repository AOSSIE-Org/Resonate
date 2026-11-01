import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
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

  static Color _inactiveButtonColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return scheme.brightness == Brightness.light
        ? scheme.onPrimary.withValues(alpha: 0.5)
        : scheme.onSurface.withValues(alpha: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final inactive = _inactiveButtonColor(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
      color: scheme.brightness == Brightness.light
          ? scheme.primary
          : scheme.surfaceContainerHighest,
      height: UiSizes.height_131,
      child: Row(
        children: [
          // Equal-width cells so long labels ellipsize instead of overflowing.
          Expanded(
            child: _CallControlButton(
              icon: isMicOn ? Icons.mic : Icons.mic_off,
              label: l10n.mute,
              onPressed: onToggleMic,
              backgroundColor: isMicOn ? inactive : scheme.primary,
              heroTag: 'mic',
            ),
          ),
          Expanded(
            child: _CallControlButton(
              icon: Icons.volume_up,
              label: l10n.speakerLabel,
              onPressed: onToggleLoudSpeaker,
              backgroundColor: isLoudSpeakerOn ? scheme.primary : inactive,
              heroTag: 'speaker',
            ),
          ),
          Expanded(
            child: _CallControlButton(
              icon: Icons.settings_voice,
              label: l10n.audioOptions,
              onPressed: onAudioSettings,
              backgroundColor: inactive,
              heroTag: 'audio-settings',
            ),
          ),
          Expanded(
            child: _CallControlButton(
              icon: Icons.cancel_outlined,
              label: l10n.end,
              onPressed: onEnd,
              backgroundColor: scheme.error,
              heroTag: 'end-chat',
            ),
          ),
        ],
      ),
    );
  }
}

class _CallControlButton extends StatelessWidget {
  const _CallControlButton({
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
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: UiSizes.height_14),
        ),
      ],
    );
  }
}
