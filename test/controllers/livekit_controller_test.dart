import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/livekit_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LiveKitController Tests', () {
    late LiveKitController controller;
    const String testUri = 'ws://test.livekit.com';
    const String testToken = 'test-token';

    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    test('onInit should be synchronous and not crash', () {
      controller = LiveKitController(
        liveKitUri: testUri,
        roomToken: testToken,
      );

      // onInit should complete immediately without throwing
      expect(() => controller.onInit(), returnsNormally);

      // Initial state should be disconnected
      expect(controller.isConnected.value, false);
      expect(controller.reconnectAttempts, 0);
    });

    test('liveKitRoom should be nullable', () {
      controller = LiveKitController(
        liveKitUri: testUri,
        roomToken: testToken,
      );

      // liveKitRoom should be null before connection
      expect(controller.liveKitRoom, isNull);
      expect(controller.listener, isNull);
    });

    test('onClose should handle null resources gracefully', () async {
      controller = LiveKitController(
        liveKitUri: testUri,
        roomToken: testToken,
      );

      // Should not crash even if liveKitRoom is null
      expect(() async => await controller.onClose(), returnsNormally);
    });

    test('isRecording should default to false', () {
      controller = LiveKitController(
        liveKitUri: testUri,
        roomToken: testToken,
        isLiveChapter: true,
      );

      expect(controller.isRecording.value, false);
    });

    test('reconnectAttempts should initialize to 0', () {
      controller = LiveKitController(
        liveKitUri: testUri,
        roomToken: testToken,
      );

      expect(controller.reconnectAttempts, 0);
    });
  });
}
