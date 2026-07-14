import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/enums/update_enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:upgrader/upgrader.dart';

part 'generated/about_app_notifier.g.dart';

class AboutAppState {
  final String appVersion;
  final String appBuildNumber;
  final bool updateAvailable;
  final bool isCheckingForUpdate;
  final bool showFullDescription;

  const AboutAppState({
    this.appVersion = "0.0.0",
    this.appBuildNumber = "1",
    this.updateAvailable = false,
    this.isCheckingForUpdate = false,
    this.showFullDescription = false,
  });

  AboutAppState copyWith({
    String? appVersion,
    String? appBuildNumber,
    bool? updateAvailable,
    bool? isCheckingForUpdate,
    bool? showFullDescription,
  }) {
    return AboutAppState(
      appVersion: appVersion ?? this.appVersion,
      appBuildNumber: appBuildNumber ?? this.appBuildNumber,
      updateAvailable: updateAvailable ?? this.updateAvailable,
      isCheckingForUpdate: isCheckingForUpdate ?? this.isCheckingForUpdate,
      showFullDescription: showFullDescription ?? this.showFullDescription,
    );
  }
}

@Riverpod(keepAlive: true)
Upgrader upgrader(Ref ref) => Upgrader(
  debugDisplayAlways: false,
  debugDisplayOnce: false,
  debugLogging: kDebugMode,
  durationUntilAlertAgain: kDebugMode
      ? const Duration(minutes: 1)
      : const Duration(days: 7),
);

@Riverpod(keepAlive: true)
class AboutApp extends _$AboutApp {
  @override
  AboutAppState build() {
    _loadPackageInfo();
    return const AboutAppState();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      state = state.copyWith(
        appVersion: packageInfo.version,
        appBuildNumber: packageInfo.buildNumber,
      );
    } catch (e) {
      log('Failed to load package info: $e');
    }
  }

  void toggleDescription() {
    state = state.copyWith(showFullDescription: !state.showFullDescription);
  }

  Future<UpdateCheckResult> checkForUpdate({
    bool isManualCheck = false,
    bool clearSettings = true,
    bool showDialog = true,
    required bool Function() onIgnore,
    required bool Function() onLater,
    bool Function()? onUpdate,
  }) async {
    state = state.copyWith(isCheckingForUpdate: true);
    final upgrader = ref.read(upgraderProvider);
    try {
      if (clearSettings) {
        Upgrader.clearSavedSettings();
      }
      await upgrader.initialize();
      final needsUpdate = upgrader.shouldDisplayUpgrade();
      state = state.copyWith(updateAvailable: needsUpdate);
      if (needsUpdate && showDialog) {
        await rootNavigatorKey.currentState?.push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => UpgradeAlert(
              upgrader: upgrader,
              onIgnore: onIgnore,
              onLater: onLater,
              onUpdate: onUpdate,
              barrierDismissible: false,
            ),
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
      state = state.copyWith(isCheckingForUpdate: false);
    }
  }
}
