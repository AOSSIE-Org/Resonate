import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/ui_sizes.dart';
import '../../controllers/voice_profile_controller.dart';

class VoiceProfileScreen extends StatelessWidget {
  VoiceProfileScreen({super.key});

  final VoiceProfileController controller =
      Get.put(VoiceProfileController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Profile'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_20,
            vertical: UiSizes.height_20,
          ),
          children: [
            // ── Section: Voice Profile Selection ────────────────────────────
            Text(
              'Select Voice Profile',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: UiSizes.height_12),
            _VoiceProfileDropdown(controller: controller),
            SizedBox(height: UiSizes.height_30),

            // ── Section: Preview Toggle ──────────────────────────────────────
            _PreviewToggleTile(controller: controller),
          ],
        ),
      ),
    );
  }
}

// ─── Voice Profile Dropdown ───────────────────────────────────────────────────

class _VoiceProfileDropdown extends StatelessWidget {
  const _VoiceProfileDropdown({required this.controller});

  final VoiceProfileController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedVoice.value,
        decoration: InputDecoration(
          labelText: 'Voice Profile',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Icon(
            Icons.record_voice_over_outlined,
            color: colorScheme.primary,
          ),
        ),
        items: controller.voiceProfiles
            .map(
              (profile) => DropdownMenuItem<String>(
                value: profile,
                child: Text(profile),
              ),
            )
            .toList(),
        onChanged: controller.onVoiceProfileChanged,
      ),
    );
  }
}

// ─── Preview Toggle Tile ──────────────────────────────────────────────────────

class _PreviewToggleTile extends StatelessWidget {
  const _PreviewToggleTile({required this.controller});

  final VoiceProfileController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => SwitchListTile(
          title: const Text('Preview Mode'),
          subtitle: Text(
            controller.isPreviewEnabled.value ? 'On' : 'Off',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          secondary: Icon(
            Icons.headphones_outlined,
            color: colorScheme.primary,
          ),
          value: controller.isPreviewEnabled.value,
          onChanged: controller.onPreviewToggled,
          activeColor: colorScheme.primary,
        ),
      ),
    );
  }
}
