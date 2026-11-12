import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:resonate/features/settings/viewmodel/about_app_notifier.dart';
import 'package:resonate/utils/enums/update_enums.dart';
import 'package:upgrader/upgrader.dart';

import 'about_app_notifier_test.mocks.dart';

@GenerateMocks([Upgrader])
void main() {
  late ProviderContainer container;
  late MockUpgrader mockUpgrader;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    PackageInfo.setMockInitialValues(
      appName: 'resonate',
      packageName: 'com.resonate.resonate',
      version: '0.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() {
    mockUpgrader = MockUpgrader();
    container = ProviderContainer(
      overrides: [upgraderProvider.overrideWithValue(mockUpgrader)],
    );
  });

  tearDown(() => container.dispose());

  AboutApp notifier() => container.read(aboutAppProvider.notifier);

  group('AboutApp notifier', () {
    test('initializes with correct default values', () {
      final state = container.read(aboutAppProvider);
      expect(state.appVersion, "0.0.0");
      expect(state.appBuildNumber, "1");
      expect(state.updateAvailable, false);
      expect(state.isCheckingForUpdate, false);
      expect(state.showFullDescription, false);
    });

    test('toggles description visibility', () {
      expect(container.read(aboutAppProvider).showFullDescription, false);
      notifier().toggleDescription();
      expect(container.read(aboutAppProvider).showFullDescription, true);
      notifier().toggleDescription();
      expect(container.read(aboutAppProvider).showFullDescription, false);
    });

    test(
      'checkForUpdate returns noUpdateAvailable when no update needed',
      () async {
        when(mockUpgrader.initialize()).thenAnswer((_) async => true);
        when(mockUpgrader.shouldDisplayUpgrade()).thenReturn(false);

        final result = await notifier().checkForUpdate(
          clearSettings: false,
          onIgnore: () => true,
          onLater: () => true,
        );

        expect(container.read(aboutAppProvider).updateAvailable, false);
        expect(result, UpdateCheckResult.noUpdateAvailable);
        verify(mockUpgrader.initialize()).called(1);
        verify(mockUpgrader.shouldDisplayUpgrade()).called(1);
      },
    );

    test(
      'checkForUpdate returns updateAvailable when update needed',
      () async {
        when(mockUpgrader.initialize()).thenAnswer((_) async => true);
        when(mockUpgrader.shouldDisplayUpgrade()).thenReturn(true);

        final result = await notifier().checkForUpdate(
          clearSettings: false,
          showDialog: false,
          onIgnore: () => true,
          onLater: () => true,
        );

        expect(container.read(aboutAppProvider).updateAvailable, true);
        expect(result, UpdateCheckResult.updateAvailable);
      },
    );
  });
}
