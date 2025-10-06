import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';
import 'package:upgrader/upgrader.dart';
import 'package:resonate/utils/enums/update_enums.dart';

class AboutAppScreenController extends GetxController {
  final Rx<String> appVersion = "0.0.0".obs;
  final Rx<String> appBuildNumber = "1".obs;
  final Rx<bool> updateAvailable = false.obs;
  final Rx<bool> isCheckingForUpdate = false.obs;

  final showFullDescription = false.obs;

  final Upgrader upgrader;

  AboutAppScreenController({Upgrader? upgrader})
    : upgrader =
          upgrader ??
          Upgrader(
            debugDisplayAlways: false,
            debugDisplayOnce: false,
            debugLogging: kDebugMode,
            durationUntilAlertAgain: kDebugMode
                ? const Duration(minutes: 1)
                : const Duration(days: 7),
          );

  @override
  void onInit() {
    super.onInit();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      appBuildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      customSnackbar(
        AppLocalizations.of(Get.context!)!.updateCheckFailed,
        AppLocalizations.of(Get.context!)!.updateCheckFailedMessage,
        LogType.error,
      );
    }
  }

  void toggleDescription() {
    showFullDescription.toggle();
  }

  Future<UpdateCheckResult> checkForUpdate({
    bool isManualCheck = false,
    bool clearSettings = true,
    bool showDialog = true,
    required bool Function() onIgnore,
    required bool Function() onLater,
    bool Function()? onUpdate,
  }) async {
    isCheckingForUpdate.value = true;
    try {
      if (clearSettings) {
        Upgrader.clearSavedSettings();
      }
      await upgrader.initialize();
      final needsUpdate = upgrader.shouldDisplayUpgrade();
      updateAvailable.value = needsUpdate;
      if (needsUpdate && showDialog) {
        await Get.to(
          UpgradeAlert(
            upgrader: upgrader,
            onIgnore: onIgnore,
            onLater: onLater,
            onUpdate: onUpdate,
            barrierDismissible: false,
          ),
        );
      }

      return needsUpdate
          ? UpdateCheckResult.updateAvailable
          : UpdateCheckResult.noUpdateAvailable;
    } catch (e) {
      log('Update check error: $e');
      return UpdateCheckResult.checkFailed;
    } finally {
      isCheckingForUpdate.value = false;
    }
  }
}
