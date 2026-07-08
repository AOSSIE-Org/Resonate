import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/rooms/viewmodel/audio_device_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/audio_device.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AudioDeviceSelectorDialog extends ConsumerWidget {
  const AudioDeviceSelectorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(audioDeviceProvider);
    final service = ref.read(audioDeviceServiceProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(UiSizes.width_2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.audioOutput,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_4),
                    Text(
                      AppLocalizations.of(context)!.selectPreferredSpeaker,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
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
          Flexible(
            child: SingleChildScrollView(
              child: asyncState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Text('$e'),
                data: (state) => _DeviceList(
                  devices: state.devices,
                  selectedDevice: state.selected,
                  displayNameFor: service.displayNameFor,
                  onSelect: (device) =>
                      ref.read(audioDeviceProvider.notifier).selectOutput(device),
                ),
              ),
            ),
          ),
          SizedBox(height: UiSizes.height_12),
          const Divider(),
          SizedBox(height: UiSizes.height_8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => ref.invalidate(audioDeviceProvider),
                icon: Icon(Icons.refresh, size: UiSizes.size_18),
                label: Text(AppLocalizations.of(context)!.refresh),
              ),
              SizedBox(width: UiSizes.width_8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(AppLocalizations.of(context)!.done),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({
    required this.devices,
    required this.selectedDevice,
    required this.displayNameFor,
    required this.onSelect,
  });

  final List<AudioDevice> devices;
  final AudioDevice? selectedDevice;
  final String Function(AudioDevice) displayNameFor;
  final ValueChanged<AudioDevice> onSelect;

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: UiSizes.height_8),
        child: Text(
          AppLocalizations.of(context)!.noAudioOutputDevices,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        final isSelected = selectedDevice?.deviceId == device.deviceId;
        return _DeviceItem(
          device: device,
          displayName: displayNameFor(device),
          iconName: device.deviceType.iconName,
          isSelected: isSelected,
          onTap: () => onSelect(device),
        );
      },
    );
  }
}

class _DeviceItem extends StatelessWidget {
  const _DeviceItem({
    required this.device,
    required this.displayName,
    required this.iconName,
    required this.isSelected,
    required this.onTap,
  });

  final AudioDevice device;
  final String displayName;
  final String iconName;
  final bool isSelected;
  final VoidCallback onTap;

  IconData _icon() {
    switch (iconName) {
      case 'bluetooth_audio':
        return Icons.bluetooth_audio;
      case 'phone':
        return Icons.phone;
      case 'headset':
        return Icons.headset;
      case 'speaker':
        return Icons.speaker;
      default:
        return Icons.volume_up;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: UiSizes.height_8),
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
          : Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiSizes.width_10),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiSizes.width_10),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_10,
            vertical: UiSizes.height_12,
          ),
          child: Row(
            children: [
              Icon(
                _icon(),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                size: UiSizes.size_24,
              ),
              SizedBox(width: UiSizes.width_10),
              Expanded(
                child: Text(
                  displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: UiSizes.size_20,
                ),
            ],
          ),
        ),
      ),
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
