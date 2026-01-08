import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/audio_device_controller.dart';
import 'package:resonate/models/audio_device.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AudioDeviceSelectorDialog extends StatelessWidget {
  final AudioDeviceController controller;
  const AudioDeviceSelectorDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
          // Drag handle
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
                onPressed: () => Get.back(),
              ),
            ],
          ),
          SizedBox(height: UiSizes.height_8),
          const Divider(),
          SizedBox(height: UiSizes.height_12),
          Flexible(
            child: Obx(
              () => SingleChildScrollView(
                child: _buildDeviceList(
                  context,
                  controller,
                  controller.audioOutputDevices,
                  controller.selectedAudioOutput.value,
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
                onPressed: () => controller.refreshDevices(),
                icon: Icon(Icons.refresh, size: UiSizes.size_18),
                label: Text(AppLocalizations.of(context)!.refresh),
              ),
              SizedBox(width: UiSizes.width_8),
              ElevatedButton(
                onPressed: () => Get.back(),
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

  Widget _buildDeviceList(
    BuildContext context,
    AudioDeviceController controller,
    List<AudioDevice> devices,
    AudioDevice? selectedDevice,
  ) {
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
        final friendlyName = controller.getDeviceName(device);
        final iconName = controller.getDeviceIcon(device);

        return _buildDeviceItem(
          context,
          device,
          friendlyName,
          iconName,
          isSelected,
          () => controller.selectAudioOutput(device),
        );
      },
    );
  }

  Widget _buildDeviceItem(
    BuildContext context,
    AudioDevice device,
    String displayName,
    String iconName,
    bool isSelected,
    VoidCallback onTap,
  ) {
    IconData icon;
    switch (iconName) {
      case 'bluetooth_audio':
        icon = Icons.bluetooth_audio;
        break;
      case 'phone':
        icon = Icons.phone;
        break;
      case 'headset':
        icon = Icons.headset;
        break;
      case 'speaker':
        icon = Icons.speaker;
        break;
      default:
        icon = Icons.volume_up;
    }

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
                icon,
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
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
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

Future<void> showAudioDeviceSelector(BuildContext context) async {
  final controller = Get.put(AudioDeviceController(), permanent: true);
  await controller.refreshDevices();

  Get.bottomSheet(
    AudioDeviceSelectorDialog(controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}
