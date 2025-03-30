import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import '../../controllers/auth_state_controller.dart';

Future<dynamic> buildPairChatDialog(BuildContext context) {
  final PairChatController controller = Get.find<PairChatController>();

  return Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              "Pair Chat",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Divider with slight padding
            Divider(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Identity Selection Section
            Text(
              "Choose Identity",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),

            // Anonymous and Authenticated Buttons
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.isAnonymous.value = true,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isAnonymous.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        elevation: controller.isAnonymous.value ? 6 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Anonymous',
                        style: TextStyle(
                            color: controller.isAnonymous.value
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            fontSize: UiSizes.size_12,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.fade),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.isAnonymous.value = false,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !controller.isAnonymous.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                        elevation: !controller.isAnonymous.value ? 6 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 5),
                      ),
                      child: Text(
                        Get.find<AuthStateController>().displayName!,
                        // "asjdwwwwwassdawdhausduuawhdaub",
                        style: TextStyle(
                            color: !controller.isAnonymous.value
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            fontSize: UiSizes.size_12,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Divider with slight padding
            Divider(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
              thickness: 1,
            ),
            const SizedBox(height: 16),

            // Language Selection Section
            Text(
              "Select Language",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            LanguagePickerDropdown(
              initialValue: Languages.english,
              onValuePicked: (Language language) {
                log(language.isoCode);
                controller.languageIso = language.isoCode;
              },
            ),
            const SizedBox(height: 28),

            // Resonate Button styled like Anonymous button
            ElevatedButton(
              onPressed: controller.quickMatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(14),
              ),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Resonate",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: UiSizes.size_16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
