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
  String _packageName = '';

  final String fullDescription = """
Resonate is a revolutionary voice-based social media platform where every voice matters. 
Join real-time audio conversations, participate in diverse discussions, and connect with 
like-minded individuals. Our platform offers:
- Live audio rooms with topic-based discussions
- Seamless social networking through voice
- Community-driven content moderation
- Cross-platform compatibility
- End-to-end encrypted private conversations

Developed by the AOSSIE open source community, we prioritize user privacy and 
community-driven development. Join us in shaping the future of social audio!""";

  @override
  void onInit() {
    super.onInit();
    _initializeUpgrader();
    _loadPackageInfo();
    _checkForUpdateOnLaunch();
  }

  void _initializeUpgrader() {
    _upgrader = Upgrader(
      debugDisplayAlways: false,
      debugDisplayOnce: false,
      debugLogging: false,
      durationUntilAlertAgain: const Duration(days: 1),
    );
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      appBuildNumber.value = packageInfo.buildNumber;
      _packageName = packageInfo.packageName;
    } catch (e) {
      print('Could not load package info: $e');
    }
  }

  void toggleDescription() {
    showFullDescription.toggle();
  }

  Future<void> _checkForUpdateOnLaunch() async {
    try {
      await _upgrader.initialize();
      final needsUpdate = _upgrader.shouldDisplayUpgrade();
      updateAvailable.value = needsUpdate;
    } catch (e) {
      log('Update check failed on launch: $e');
      updateAvailable.value = false;
    }
  }

  Future<UpdateCheckResult> checkForUpdate() async {
    isCheckingForUpdate.value = true;
    try {
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
            'https://play.google.com/store/apps/details?id=$_packageName';
      } else if (Platform.isIOS) {
        // Replace with App Store URL when available
        storeUrl = 'https://apps.apple.com/search?term=resonate%20aossie';
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
