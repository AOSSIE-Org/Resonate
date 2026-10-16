import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/features/stories/model/live_chapter_state.dart';
import 'package:resonate/features/stories/model/stories_failure.dart';
import 'package:resonate/features/stories/view/widgets/start_live_chapter_dialog.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';


class _StartableLiveChapter extends LiveChapter {
  _StartableLiveChapter({this.fails});

  final Object? fails;
  Completer<void>? gate;
  ({String title, String description, String storyId, String storyName})?
  started;

  @override
  LiveChapterState build() => const LiveChapterState();

  @override
  Future<void> startLiveChapter({
    required String chapterTitle,
    required String chapterDescription,
    required String storyId,
    required String storyName,
    String? roomId,
  }) async {
    started = (
      title: chapterTitle,
      description: chapterDescription,
      storyId: storyId,
      storyName: storyName,
    );
    if (gate != null) await gate!.future;
    if (fails != null) throw fails!;
  }
}

void main() {
  late _StartableLiveChapter coordinator;
  late GoRouter router;

  void makeRouter() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) =>
                      StartLiveChapterDialog(story: fakeStory(storyId: 's1')),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: RoutePaths.liveChapterScreen,
          builder: (_, _) => const Scaffold(body: Text('live chapter screen')),
        ),
      ],
    );
  }

  setUp(makeRouter);
  tearDown(() => router.dispose());

  Future<void> openDialog(
    WidgetTester tester, {
    Object? fails,
    Completer<void>? gate,
  }) async {
    coordinator = _StartableLiveChapter(fails: fails)..gate = gate;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [liveChapterProvider.overrideWith(() => coordinator)],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          builder: (context, child) {
            UiSizes.init(context);
            return child!;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> fill(
    WidgetTester tester, {
    String title = 'Chapter One',
    String description = 'How it begins',
  }) async {
    await tester.enterText(find.byType(TextFormField).at(0), title);
    await tester.enterText(find.byType(TextFormField).at(1), description);
    await tester.pumpAndSettle();
  }

  Future<void> tapStart(WidgetTester tester) async {
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
  }

  group('validation', () {
    testWidgets('a missing description does not start anything', (
      tester,
    ) async {
      await openDialog(tester);

      await fill(tester, description: '');
      await tapStart(tester);

      expect(coordinator.started, isNull);
      expect(find.byType(StartLiveChapterDialog), findsOneWidget);
    });

    // Whitespace is trimmed, so a field of spaces is still empty.
    testWidgets('whitespace-only fields count as empty', (tester) async {
      await openDialog(tester);

      await fill(tester, title: '   ', description: '   ');
      await tapStart(tester);

      expect(coordinator.started, isNull);
    });
  });

  group('starting', () {
    testWidgets('passes the trimmed details and the story', (tester) async {
      await openDialog(tester);

      await fill(tester, title: '  Chapter One  ');
      await tapStart(tester);

      expect(coordinator.started?.title, 'Chapter One');
      expect(coordinator.started?.description, 'How it begins');
      expect(coordinator.started?.storyId, 's1');
    });

    testWidgets('closes the dialog and opens the live screen', (tester) async {
      await openDialog(tester);

      await fill(tester);
      await tapStart(tester);

      expect(find.byType(StartLiveChapterDialog), findsNothing);
      expect(find.text('live chapter screen'), findsOneWidget);
    });

    // Creating the room takes a moment; the buttons lock so it cannot be
    // started twice.
    testWidgets('shows progress and disables both buttons while it works', (
      tester,
    ) async {
      final gate = Completer<void>();
      await openDialog(tester, gate: gate);
      await fill(tester);

      await tester.tap(find.text('Start'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Scoped to the dialog: the page behind it has its own button.
      final buttons = tester.widgetList<ElevatedButton>(
        find.descendant(
          of: find.byType(StartLiveChapterDialog),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(buttons.every((b) => b.onPressed == null), isTrue);

      gate.complete();
      await tester.pumpAndSettle();
    });
  });

  group('when starting fails', () {
    testWidgets('the dialog stays open and unlocks', (tester) async {
      await openDialog(
        tester,
        fails: const StoriesFailure.unknown('room service down'),
      );

      await fill(tester);
      await tapStart(tester);

      expect(find.byType(StartLiveChapterDialog), findsOneWidget);
      expect(find.text('live chapter screen'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('an upload failure is handled the same way', (tester) async {
      await openDialog(
        tester,
        fails: const StoriesFailure.upload('cover image'),
      );

      await fill(tester);
      await tapStart(tester);

      expect(find.byType(StartLiveChapterDialog), findsOneWidget);
    });

    testWidgets('so is any other error', (tester) async {
      await openDialog(tester, fails: Exception('something else'));

      await fill(tester);
      await tapStart(tester);

      expect(find.byType(StartLiveChapterDialog), findsOneWidget);
    });
  });

  testWidgets('cancel closes without starting', (tester) async {
    await openDialog(tester);
    await fill(tester);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(coordinator.started, isNull);
    expect(find.byType(StartLiveChapterDialog), findsNothing);
  });
}
