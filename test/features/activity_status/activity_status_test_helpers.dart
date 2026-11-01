import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

export '../../helpers/test_root_container.dart';

export 'package:flutter_riverpod/misc.dart' show Override;

export 'package:resonate/utils/enums/activity_status.dart';

Widget activityStatusTestApp(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme,
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

Future<void> pumpActivityStatusWidget(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  ThemeData? theme,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: activityStatusTestApp(child, theme: theme),
    ),
  );
}

// Wraps the body in mockNetworkImagesFor so avatar NetworkImages don't fetch.
void testActivityStatusWidget(
  String description,
  Future<void> Function(WidgetTester tester) body,
) {
  testWidgets(
    description,
    (tester) => mockNetworkImagesFor(() => body(tester)),
  );
}
