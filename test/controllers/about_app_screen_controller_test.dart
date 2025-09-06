import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';

void main() {
  late AboutAppScreenController controller;

  setUp(() {
    controller = AboutAppScreenController();
  });

  group('AboutAppScreenController Tests', () {
    test('should initialize with correct default values', () {
      expect(controller.appVersion.value, "0.0.0");
      expect(controller.appBuildNumber.value, "1");
      expect(controller.updateAvailable.value, false);
      expect(controller.isCheckingForUpdate.value, false);
      expect(controller.showFullDescription.value, false);
    });

    test('should initialize upgrader after onInit', () {
      controller.onInit();
      expect(controller.upgrader, isNotNull);
    });

    test('should toggle description visibility', () {
      expect(controller.showFullDescription.value, false);

      controller.toggleDescription();
      expect(controller.showFullDescription.value, true);

      controller.toggleDescription();
      expect(controller.showFullDescription.value, false);
    });

    test('should handle multiple toggles correctly', () {
      expect(controller.showFullDescription.value, false);

      for (int i = 0; i < 4; i++) {
        controller.toggleDescription();
        expect(controller.showFullDescription.value, i % 2 == 0);
      }
    });

    test('checkForUpdate should return valid result and reset flag', () async {
      expect(controller.isCheckingForUpdate.value, false);

      final result = await controller.checkForUpdate();

      expect(result, isA<UpdateCheckResult>());
      expect(controller.isCheckingForUpdate.value, false);
    });

    test(
      'checkForUpdate should return platformNotSupported on desktop',
      () async {
        if (!Platform.isAndroid && !Platform.isIOS) {
          final result = await controller.checkForUpdate();
          expect(result, UpdateCheckResult.platformNotSupported);
        }
      },
    );

    test('launchStoreForUpdate should return valid result', () async {
      final result = await controller.launchStoreForUpdate();
      expect(result, isA<UpdateActionResult>());

      if (!Platform.isAndroid && !Platform.isIOS) {
        expect(result, UpdateActionResult.error);
      }
    });
    test('static checkForUpdatesOnLaunch should return boolean', () async {
      final result = await AboutAppScreenController.checkForUpdatesOnLaunch();
      expect(result, isA<bool>());

      if (!Platform.isAndroid && !Platform.isIOS) {
        expect(result, false);
      }
    });

    test('should handle package info loading after onInit', () async {
      controller.onInit();
      await Future.delayed(Duration(milliseconds: 100));

      expect(controller.appVersion.value, isA<String>());
      expect(controller.appBuildNumber.value, isA<String>());
      expect(controller.appVersion.value.isNotEmpty, true);
      expect(controller.appBuildNumber.value.isNotEmpty, true);
    });

    test('should not crash when accessing upgrader before onInit', () {
      expect(() => controller.upgrader, throwsA(isA<Error>()));
    });

    test('should not allow multiple onInit calls on same instance', () {
      controller.onInit();
      expect(() => controller.onInit(), throwsA(isA<Error>()));
    });
  });
}
