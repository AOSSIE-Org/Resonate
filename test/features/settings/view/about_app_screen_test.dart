import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/settings/view/pages/about_app_screen.dart';
import 'package:resonate/features/settings/viewmodel/about_app_notifier.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/update_enums.dart';

import '../settings_test_helpers.dart';

const _urlLauncherChannel = MethodChannel('plugins.flutter.io/url_launcher');

class FakeAboutApp extends AboutApp {
  FakeAboutApp(this._initial);
  final AboutAppState _initial;
  int checkForUpdateCount = 0;

  @override
  AboutAppState build() => _initial;

  @override
  Future<UpdateCheckResult> checkForUpdate({
    bool isManualCheck = false,
    bool clearSettings = true,
    bool showDialog = true,
    required bool Function() onIgnore,
    required bool Function() onLater,
    bool Function()? onUpdate,
  }) async {
    checkForUpdateCount++;
    return UpdateCheckResult.noUpdateAvailable;
  }
}

List<Override> overridesWith(AboutAppState state, {FakeAboutApp? fake}) {
  return [
    aboutAppProvider.overrideWith(() => fake ?? FakeAboutApp(state)),
  ];
}

Future<void> pumpAboutApp(
  WidgetTester tester,
  List<Override> overrides,
) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: settingsTestApp(const AboutAppScreen()),
    ),
  );
}

void main() {
  late List<MethodCall> launches;

  setUp(() {
    launches = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_urlLauncherChannel, (call) async {
          launches.add(call);
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_urlLauncherChannel, null);
  });

  String? launchedUrl() {
    if (launches.isEmpty) return null;
    final args = launches.last.arguments;
    return args is Map ? args['url'] as String? : null;
  }

  // The framework asserts that foundation debug overrides are cleared before
  // the test body returns, so the override cannot live in addTearDown.
  Future<void> tapRateOn(WidgetTester tester, TargetPlatform platform) async {
    debugDefaultTargetPlatformOverride = platform;
    try {
      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  }

  testWidgets('renders the version string from aboutApp state', (tester) async {
    const state = AboutAppState(appVersion: '2.5.1', appBuildNumber: '42');
    await pumpAboutApp(tester, overridesWith(state));
    await tester.pumpAndSettle();

    expect(find.text('2.5.1 | 42 | Stable'), findsOneWidget);
  });

  testWidgets('shows checkForUpdates label + update icon when no update', (
    tester,
  ) async {
    const state = AboutAppState(updateAvailable: false);
    await pumpAboutApp(tester, overridesWith(state));
    await tester.pumpAndSettle();

    expect(find.text('Check Updates'), findsOneWidget);
    expect(find.byIcon(Icons.update), findsOneWidget);
    expect(find.byIcon(Icons.system_update), findsNothing);
  });

  testWidgets('shows updateAvailable label + system_update icon when update', (
    tester,
  ) async {
    const state = AboutAppState(updateAvailable: true);
    await pumpAboutApp(tester, overridesWith(state));
    await tester.pumpAndSettle();

    expect(find.text('Update Available'), findsOneWidget);
    expect(find.byIcon(Icons.system_update), findsOneWidget);
    expect(find.byIcon(Icons.update), findsNothing);
  });

  testWidgets('shows the LoadingIndicator (not the icon) while checking', (
    tester,
  ) async {
    const state = AboutAppState(isCheckingForUpdate: true);
    await pumpAboutApp(tester, overridesWith(state));
    await tester.pump();

    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.byIcon(Icons.update), findsNothing);
    expect(find.byIcon(Icons.system_update), findsNothing);
  });

  testWidgets('tapping the check-for-update tile invokes checkForUpdate', (
    tester,
  ) async {
    final fake = FakeAboutApp(const AboutAppState());
    await pumpAboutApp(
      tester,
      overridesWith(const AboutAppState(), fake: fake),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Check Updates'));
    await tester.pumpAndSettle();

    expect(fake.checkForUpdateCount, 1);
  });

  testWidgets('logo Semantics labels are present', (tester) async {
    await pumpAboutApp(tester, overridesWith(const AboutAppState()));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Resonate Logo'), findsOneWidget);
    expect(find.bySemanticsLabel('aossie logo'), findsOneWidget);
  });

  group('rating the app', () {
    testWidgets('opens the Play Store on Android', (tester) async {
      await pumpAboutApp(tester, overridesWith(const AboutAppState()));
      await tester.pumpAndSettle();

      await tapRateOn(tester, TargetPlatform.android);

      expect(launchedUrl(), playStoreUrl);
    });

    testWidgets('opens the App Store on iOS', (tester) async {
      await pumpAboutApp(tester, overridesWith(const AboutAppState()));
      await tester.pumpAndSettle();

      await tapRateOn(tester, TargetPlatform.iOS);

      expect(launchedUrl(), appStoreUrl);
    });

    testWidgets('a launcher that refuses leaves the page standing', (
      tester,
    ) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_urlLauncherChannel, (call) async {
            throw PlatformException(code: 'no handler');
          });

      await pumpAboutApp(tester, overridesWith(const AboutAppState()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.star_rate_outlined), findsOneWidget);
    });

    testWidgets('a launcher that returns false leaves the page standing', (
      tester,
    ) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_urlLauncherChannel, (call) async => false);

      await pumpAboutApp(tester, overridesWith(const AboutAppState()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.star_rate_outlined));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.star_rate_outlined), findsOneWidget);
    });
  });
}
