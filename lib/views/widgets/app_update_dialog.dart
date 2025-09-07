import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AppUpdateDialog extends StatelessWidget {
  AppUpdateDialog({super.key});
  final AboutAppScreenController controller =
      Get.find<AboutAppScreenController>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiSizes.width_16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: Theme.of(context).primaryColor,
            size: UiSizes.size_28,
          ),
          SizedBox(width: UiSizes.width_10),
          Expanded(
            child: Text(
              l10n.updateAvailableTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.updateAvailableMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: UiSizes.height_16),
          Container(
            padding: EdgeInsets.all(UiSizes.width_10),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withAlpha(50),
              borderRadius: BorderRadius.circular(UiSizes.width_8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(100),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).iconTheme.color,
                  size: UiSizes.size_20,
                ),
                SizedBox(width: UiSizes.width_8),
                Expanded(
                  child: Text(
                    l10n.updateFeaturesImprovement,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            l10n.updateLater,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            Get.back();
            await controller.launchStoreForUpdate();
          },
          icon: Icon(Icons.download, size: UiSizes.size_18),
          label: Text(l10n.updateNow),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_20,
              vertical: UiSizes.height_12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiSizes.width_8),
            ),
          ),
        ),
      ],
      actionsPadding: EdgeInsets.fromLTRB(
        UiSizes.width_20,
        0,
        UiSizes.width_20,
        UiSizes.height_20,
      ),
    );
  }
}
