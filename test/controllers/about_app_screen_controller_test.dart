import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:upgrader/upgrader.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/utils/enums/update_enums.dart';
import 'about_app_screen_controller_test.mocks.dart';

@GenerateMocks([Upgrader])
void main() {
  late AboutAppScreenController controller;
  late MockUpgrader mockUpgrader;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockUpgrader = MockUpgrader();
    controller = AboutAppScreenController(upgrader: mockUpgrader);
  });

  tearDown(() {
    Get.reset();
  });

  group('AboutAppScreenController Tests', () {
    test('should initialize with correct default values', () {
      expect(controller.appVersion.value, "0.0.0");
      expect(controller.appBuildNumber.value, "1");
      expect(controller.updateAvailable.value, false);
      expect(controller.isCheckingForUpdate.value, false);
      expect(controller.showFullDescription.value, false);
    });

    test('should toggle description visibility', () {
      expect(controller.showFullDescription.value, false);
      controller.toggleDescription();
      expect(controller.showFullDescription.value, true);
      controller.toggleDescription();
      expect(controller.showFullDescription.value, false);
    });

    test(
      'checkForUpdate should return noUpdateAvailable when no update needed',
      () async {
        when(mockUpgrader.initialize()).thenAnswer((_) async => true);
        when(mockUpgrader.shouldDisplayUpgrade()).thenReturn(false);

        final result = await controller.checkForUpdate(
          clearSettings: false,
          onIgnore: () {
            Get.back();
            return true;
          },
          onLater: () {
            Get.back();
            return true;
          },
        );

        expect(controller.updateAvailable.value, false);
        expect(result, UpdateCheckResult.noUpdateAvailable);
        verify(mockUpgrader.initialize()).called(1);
        verify(mockUpgrader.shouldDisplayUpgrade()).called(1);
      },
    );

    test(
      'checkForUpdate should return updateAvailable when update needed',
      () async {
        when(mockUpgrader.initialize()).thenAnswer((_) async => true);
        when(mockUpgrader.shouldDisplayUpgrade()).thenReturn(true);

        final result = await controller.checkForUpdate(
          onIgnore: () {
            Get.back();
            return true;
          },
          onLater: () {
            Get.back();
            return true;
          },
          clearSettings: false,
          showDialog: false,
        );

        expect(controller.updateAvailable.value, true);
        expect(result, UpdateCheckResult.updateAvailable);
      },
    );
  });
}
