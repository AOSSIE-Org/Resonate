import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

Widget storiesTestApp(Widget child) {
  return MaterialApp(
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

/// Image.network can't load under flutter_test
void clearImageLoadErrors(WidgetTester tester) {
  while (tester.takeException() != null) {}
}

Future<void> pumpStoriesPage(
  WidgetTester tester,
  Widget child, {
  required ProviderContainer container,
}) async {
  addTearDown(container.dispose);
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: storiesTestApp(child),
    ),
  );
}
