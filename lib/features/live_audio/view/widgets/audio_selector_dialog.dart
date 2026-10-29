import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/live_audio/model/audio_device_state.dart';
import 'package:resonate/features/live_audio/viewmodel/audio_device_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AudioDeviceSelectorDialog extends ConsumerWidget {
  const AudioDeviceSelectorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(audioDeviceProvider);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiSizes.width_20),
        ),
      ),
      padding: EdgeInsets.only(
        left: UiSizes.width_20,
        right: UiSizes.width_20,
        top: UiSizes.height_8,
        bottom: MediaQuery.of(context).viewInsets.bottom + UiSizes.height_20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: UiSizes.width_40,
              height: UiSizes.height_4,
              margin: EdgeInsets.only(bottom: UiSizes.height_20),
              decoration: BoxDecoration(
                color: scheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(UiSizes.width_2),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.audioOutput,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_4),
                    Text(
                      l10n.selectPreferredSpeaker,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: UiSizes.height_8),
          const Divider(),
          SizedBox(height: UiSizes.height_12),
          if (!state.canSwitch)
            Padding(
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_12),
              child: Text(
                l10n.audioOutputNotSwitchable,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            )
          else ...[
            _RouteTile(
              route: AudioOutputRoute.speaker,
              icon: Icons.volume_up,
              label: l10n.loudspeaker,
              selected: state.route == AudioOutputRoute.speaker,
            ),
            _RouteTile(
              route: AudioOutputRoute.earpiece,
              icon: Icons.phone_in_talk,
              label: l10n.earpiece,
              selected: state.route == AudioOutputRoute.earpiece,
            ),
            SizedBox(height: UiSizes.height_12),
            // Android and iOS both hand a connected headset priority over the
            // loudspeaker, and neither reports it as a separate choice here.
            Text(
              l10n.headsetTakesPriority,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
          SizedBox(height: UiSizes.height_12),
          const Divider(),
          SizedBox(height: UiSizes.height_8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
              child: Text(l10n.done),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteTile extends ConsumerWidget {
  const _RouteTile({
    required this.route,
    required this.icon,
    required this.label,
    required this.selected,
  });

  final AudioOutputRoute route;
  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      key: ValueKey('audio-route-${route.name}'),
      contentPadding: EdgeInsets.symmetric(horizontal: UiSizes.width_8),
      leading: Icon(icon, color: selected ? scheme.primary : scheme.onSurface),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? scheme.primary : scheme.onSurface,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_circle, color: scheme.primary)
          : null,
      onTap: () => ref.read(audioDeviceProvider.notifier).selectRoute(route),
    );
  }
}

Future<void> showAudioDeviceSelector(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const AudioDeviceSelectorDialog(),
  );
}
