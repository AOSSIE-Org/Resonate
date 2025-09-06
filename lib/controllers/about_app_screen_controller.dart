import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpdateCheckResult {
  updateAvailable,
  noUpdateAvailable,
  checkFailed,
  platformNotSupported,
}

enum UpdateActionResult { success, userDenied, failed, error }

class AboutAppScreenController extends GetxController {
  final Rx<String> appVersion = "0.0.0".obs;
  final Rx<String> appBuildNumber = "1".obs;
  final Rx<bool> updateAvailable = false.obs;
  final Rx<bool> isCheckingForUpdate = false.obs;

  final showFullDescription = false.obs;

  late final Upgrader _upgrader;
  Upgrader get upgrader => _upgrader;

  @override
  void onInit() {
    super.onInit();
    _initializeUpgrader();
    loadPackageInfo();
  }

  void _initializeUpgrader() {
    _upgrader = Upgrader(
      debugDisplayAlways: false,
      debugDisplayOnce: false,
      debugLogging: false,
      durationUntilAlertAgain: const Duration(days: 1),
    );
  }

  static Future<bool> checkForUpdatesOnLaunch() async {
    try {
      final upgrader = Upgrader(
        debugDisplayAlways: false,
        debugDisplayOnce: false,
        debugLogging: false,
        durationUntilAlertAgain: const Duration(days: 1),
      );

      await upgrader.initialize();
      final needsUpdate = upgrader.shouldDisplayUpgrade();

      log('App launch update check: Update available = $needsUpdate');
      return needsUpdate;
    } catch (e) {
      log('Update check failed on app launch: $e');
      return false;
    }
  }

  Future<void> loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      appBuildNumber.value = packageInfo.buildNumber;
    } catch (e) {
      log('Could not load package info: $e');
    }
  }

  void toggleDescription() {
    showFullDescription.toggle();
  }

  Future<UpdateCheckResult> checkForUpdate() async {
    isCheckingForUpdate.value = true;
    try {
      if (!Platform.isAndroid && !Platform.isIOS) {
        return UpdateCheckResult.platformNotSupported;
      }
      Upgrader.clearSavedSettings();
      await _upgrader.initialize();
      final needsUpdate = _upgrader.shouldDisplayUpgrade();
      updateAvailable.value = needsUpdate;
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

  Future<UpdateActionResult> launchStoreForUpdate() async {
    try {
      String storeUrl;
      if (Platform.isAndroid) {
        storeUrl =
            'https://play.google.com/store/apps/details?id=com.resonate.resonate';
      } else if (Platform.isIOS) {
        // The App Store URL of app
        storeUrl = '';
      } else {
        return UpdateActionResult.error;
      }
      final uri = Uri.parse(storeUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return UpdateActionResult.success;
      } else {
        return UpdateActionResult.failed;
      }
    } catch (e) {
      log('Update error: $e');
      return UpdateActionResult.error;
    }
  }
}
