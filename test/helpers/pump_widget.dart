import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/achievements/model/achievement_badge.dart';
import 'package:resonate/features/achievements/model/user_stats.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/ui_sizes.dart';

import 'test_root_container.dart';

export 'package:flutter_riverpod/misc.dart' show Override;

// `rootOverlay` attaches the real root navigator key, which is where
// customSnackbar inserts its toast — without it the toast silently no-ops.
Widget testApp(Widget child, {bool rootOverlay = false}) {
  return MaterialApp(
    navigatorKey: rootOverlay ? rootNavigatorKey : null,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    home: Builder(
      builder: (context) {
        UiSizes.init(context);
        return Scaffold(body: child);
      },
    ),
  );
}

Future<void> pumpTestApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  UserStats myStats = UserStats.empty,
  Map<String, UserStats> otherStats = const {},
  List<AchievementBadge> catalogue = kDefaultBadges,
  FakeActivityRecorder? activityRecorder,
  FakeMyStats? myStatsNotifier,
  bool rootOverlay = false,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      // Parameters rather than extra entries: Riverpod asserts on a double override.
      overrides: [
        ...avatarOverrides(),
        ...achievementOverrides(
          myStats: myStats,
          otherStats: otherStats,
          catalogue: catalogue,
          recorder: activityRecorder,
          myStatsNotifier: myStatsNotifier,
        ),
        ...overrides,
      ],
      child: testApp(child, rootOverlay: rootOverlay),
    ),
  );
}

void testAppWidget(
  String description,
  Future<void> Function(WidgetTester tester) body,
) {
  testWidgets(
    description,
    (tester) => mockNetworkImagesFor(() => body(tester)),
  );
}
