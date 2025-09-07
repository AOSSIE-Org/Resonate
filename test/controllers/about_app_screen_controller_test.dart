import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:upgrader/upgrader.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/utils/enums/update_enums.dart';

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

    test(
      'checkForUpdate should manage isCheckingForUpdate flag correctly',
      () async {
        if (!Platform.isAndroid && !Platform.isIOS) {
          return;
        }
        expect(controller.isCheckingForUpdate.value, false);
        final futureResult = controller.checkForUpdate();
        expect(controller.isCheckingForUpdate.value, true);
        final result = await futureResult;
        expect(controller.isCheckingForUpdate.value, false);
        expect(
          result,
          isIn([
            UpdateCheckResult.updateAvailable,
            UpdateCheckResult.noUpdateAvailable,
            UpdateCheckResult.checkFailed,
          ]),
        );
      },
    );

    test(
      'checkForUpdate with isManualCheck should set updateAvailable and handle dialogs',
      () async {
        if (!Platform.isAndroid && !Platform.isIOS) {
          return;
        }
        expect(controller.updateAvailable.value, false);
        final result = await controller.checkForUpdate(isManualCheck: true);
        if (result == UpdateCheckResult.updateAvailable) {
          expect(controller.updateAvailable.value, true);
        } else if (result == UpdateCheckResult.noUpdateAvailable) {
          expect(controller.updateAvailable.value, false);
        } else if (result == UpdateCheckResult.checkFailed) {
          expect(controller.updateAvailable.value, false);
        }
        expect(controller.isCheckingForUpdate.value, false);
        expect(
          result,
          isIn([
            UpdateCheckResult.updateAvailable,
            UpdateCheckResult.noUpdateAvailable,
            UpdateCheckResult.checkFailed,
          ]),
        );
      },
    );

    test(
      'checkForUpdate with launchUpdateIfAvailable should set updateAvailable correctly',
      () async {
        if (!Platform.isAndroid && !Platform.isIOS) {
          return;
        }
        expect(controller.updateAvailable.value, false);
        final result = await controller.checkForUpdate(
          launchUpdateIfAvailable: true,
        );
        if (result == UpdateCheckResult.updateAvailable) {
          expect(controller.updateAvailable.value, true);
        } else if (result == UpdateCheckResult.noUpdateAvailable) {
          expect(controller.updateAvailable.value, false);
        } else if (result == UpdateCheckResult.checkFailed) {
          expect(controller.updateAvailable.value, false);
        }
        expect(controller.isCheckingForUpdate.value, false);
        expect(
          result,
          isIn([
            UpdateCheckResult.updateAvailable,
            UpdateCheckResult.noUpdateAvailable,
            UpdateCheckResult.checkFailed,
          ]),
        );
      },
    );

    test(
      'launchStoreForUpdate should return specific result based on platform',
      () async {
        final result = await controller.launchStoreForUpdate();

        if (Platform.isAndroid || Platform.isIOS) {
          expect(
            result,
            isIn([
              UpdateActionResult.success,
              UpdateActionResult.failed,
              UpdateActionResult.error,
            ]),
          );
        } else {
          expect(result, UpdateActionResult.error);
        }
      },
    );

    test('should access upgrader at any time since it is final', () {
      expect(controller.upgrader, isNotNull);
      expect(controller.upgrader, isA<Upgrader>());
    });
  });
}
