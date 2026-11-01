import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resonate/features/settings/view/pages/contribute_screen.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/pump_widget.dart';

const _channel = MethodChannel('plugins.flutter.io/url_launcher');

void main() {
  late List<MethodCall> launches;

  setUp(() {
    launches = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          launches.add(call);
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  String? launchedUrl() {
    if (launches.isEmpty) return null;
    final args = launches.last.arguments;
    return args is Map ? args['url'] as String? : null;
  }

  Future<void> pumpContribute(WidgetTester tester) async {
    await pumpTestApp(tester, const ContributeScreen());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  group('the page', () {
    testAppWidget('offers the repo and both community links', (tester) async {
      await pumpContribute(tester);

      expect(find.text('Source code on GitHub'), findsOneWidget);
      expect(find.text('Join Community'), findsOneWidget);
      expect(find.byTooltip('Follow us on X'), findsOneWidget);
      expect(find.byTooltip('Join discord server'), findsOneWidget);
    });

    testAppWidget('explains what the community is for', (tester) async {
      await pumpContribute(tester);

      expect(find.textContaining('Clear your doubts'), findsOneWidget);
    });
  });

  group('opening a link', () {
    testAppWidget('the repo row opens the GitHub project', (tester) async {
      await pumpContribute(tester);

      await tester.tap(find.text('Source code on GitHub'));
      await tester.pumpAndSettle();

      expect(launches, hasLength(1));
      expect(launchedUrl(), githubRepoUrl);
    });

    testAppWidget('the X button opens the X page', (tester) async {
      await pumpContribute(tester);

      await tester.tap(find.byIcon(FontAwesomeIcons.xTwitter));
      await tester.pumpAndSettle();

      expect(launchedUrl(), xPageUrl);
    });

    testAppWidget('the Discord button opens the invite', (tester) async {
      await pumpContribute(tester);

      await tester.tap(find.byIcon(Icons.discord));
      await tester.pumpAndSettle();

      expect(launchedUrl(), discordRepoUrl);
    });

    // Each row targets its own destination; tapping one must not fire another.
    testAppWidget('each link is opened on its own', (tester) async {
      await pumpContribute(tester);

      await tester.tap(find.byIcon(Icons.discord));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(FontAwesomeIcons.xTwitter));
      await tester.pumpAndSettle();

      expect(launches, hasLength(2));
      expect(launchedUrl(), xPageUrl);
    });

    testAppWidget('a launcher that refuses leaves the page standing', (
      tester,
    ) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_channel, (call) async {
            throw PlatformException(code: 'no handler');
          });

      await pumpContribute(tester);
      await tester.tap(find.text('Source code on GitHub'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Source code on GitHub'), findsOneWidget);
    });
  });
}
