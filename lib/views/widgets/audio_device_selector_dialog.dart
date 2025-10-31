import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/audio_device_controller.dart';
import 'package:resonate/models/audio_device.dart';

class AudioDeviceSelectorDialog extends StatelessWidget {
  const AudioDeviceSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioDeviceController controller = Get.find<AudioDeviceController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audio Output',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.005,
                      ),
                      Text(
                        'Microphone will auto-select',
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            const Divider(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Divider(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => controller.refreshDevices(),
                  icon: Icon(
                    Icons.refresh,
                    size: MediaQuery.of(context).size.width * 0.045,
                  ),
                  label: const Text('Refresh'),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
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
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Text(
          'No audio output devices detected',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      children: devices.map((device) {
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
      }).toList(),
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
      case 'headset_mic':
        icon = Icons.headset_mic;
        break;
      case 'mic':
        icon = Icons.mic;
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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      elevation: isSelected ? 2 : 0,
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
          : Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.015,
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
                size: screenWidth * 0.06,
              ),
              SizedBox(width: screenWidth * 0.03),
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
                  size: screenWidth * 0.05,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAudioDeviceSelector(BuildContext context) {
  if (!Get.isRegistered<AudioDeviceController>()) {
    Get.put(AudioDeviceController());
  }

  showDialog(
    context: context,
    builder: (context) => const AudioDeviceSelectorDialog(),
  );
}
