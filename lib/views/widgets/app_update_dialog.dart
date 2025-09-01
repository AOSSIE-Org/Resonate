import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key});

  static Future<void> showIfUpdateAvailable() async {
    final hasUpdate =
        await AboutAppScreenController.checkForUpdateOnAppLaunch();

    if (hasUpdate) {
      Get.dialog(const AppUpdateDialog(), barrierDismissible: false);
    }
  }

  Future<void> _handleUpdate() async {
    final controller = AboutAppScreenController();
    controller.onInit();

    Get.back();

    final result = await controller.launchStoreForUpdate();

    switch (result) {
      case UpdateActionResult.failed:
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.updateFailed,
          AppLocalizations.of(Get.context!)!.updateFailedMessage,
          icon: const Icon(Icons.error, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case UpdateActionResult.error:
        Get.snackbar(
          AppLocalizations.of(Get.context!)!.updateError,
          AppLocalizations.of(Get.context!)!.updateErrorMessage,
          icon: const Icon(Icons.error_outline, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      default:
        break;
    }
  }

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
              color: Theme.of(context).primaryColor.withAlpha(10),
              borderRadius: BorderRadius.circular(UiSizes.width_8),
              border: Border.all(
                color: Theme.of(context).primaryColor.withAlpha(30),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                  size: UiSizes.size_20,
                ),
                SizedBox(width: UiSizes.width_8),
                Expanded(
                  child: Text(
                    'Get the latest features and improvements!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
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
          onPressed: _handleUpdate,
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
