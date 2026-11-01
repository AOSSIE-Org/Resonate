import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/shell/viewmodel/tabview_notifier.dart';
import 'package:resonate/features/stories/data/repositories/recorded_chapters_repository.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/model/live_chapter_state.dart';
import 'package:resonate/features/stories/view/pages/verify_chapter_details_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../fake_stories_repository.dart';
import 'stories_test_helpers.dart';

class _RecordedChapterRepository extends FakeStoriesRepository {
  ({String chapterId, String title, String lyrics})? built;
  ({List<Chapter> chapters, String storyId})? added;
  Object? addThrows;

  @override
  Future<Chapter> buildRecordedChapter({
    required String chapterId,
    required String title,
    required String description,
    required String coverImgPath,
    required String audioFilePath,
    required String lyrics,
  }) async {
    built = (chapterId: chapterId, title: title, lyrics: lyrics);
    return Chapter(
      chapterId: chapterId,
      title: title,
      coverImageUrl: coverImgPath,
      description: description,
      lyrics: lyrics,
      audioFileUrl: audioFilePath,
      playDuration: 1000,
      tintColor: const Color(0xffcbc6c6),
    );
  }

  @override
  Future<void> addChaptersToStory(
    List<Chapter> chapters,
    String storyId,
  ) async {
    if (addThrows != null) throw addThrows!;
    added = (chapters: chapters, storyId: storyId);
  }
}

class _FakeRecordedChapters implements RecordedChaptersRepository {
  ({String id, String title, String transcript})? updated;

  @override
  Future<void> updateDetails({
    required String id,
    required String title,
    required String description,
    required String transcript,
  }) async {
    updated = (id: id, title: title, transcript: transcript);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not faked');
}

class _RecordingTabView extends TabView {
  final List<int> setIndexCalls = [];

  @override
  int build() => 0;

  @override
  void setIndex(int index) => setIndexCalls.add(index);
}

// path_provider has no Dart-side fake here; stubbing its channel is enough.
void stubPathProviderChannel() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (call) async => '/tmp/resonate-docs',
      );
}

void main() {
  late _RecordedChapterRepository repo;
  late _FakeRecordedChapters recordings;
  late _RecordingTabView tabView;
  late GoRouter router;

  setUp(() {
    stubPathProviderChannel();
    repo = _RecordedChapterRepository();
    recordings = _FakeRecordedChapters();
    tabView = _RecordingTabView();
    router = GoRouter(
      initialLocation: RoutePaths.verifyChapterDetails,
      routes: [
        GoRoute(
          path: RoutePaths.verifyChapterDetails,
          builder: (_, _) => const VerifyChapterDetailsPage(),
        ),
        GoRoute(
          path: RoutePaths.tabview,
          builder: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  });

  tearDown(() => router.dispose());

  String location() => router.routeInformationProvider.value.uri.toString();

  Future<void> pumpVerify(
    WidgetTester tester, {
    AsyncValue<String> transcript = const AsyncValue.data('a transcript'),
    bool withModel = true,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = LiveChapterState(
      model: withModel
          ? fakeLiveChapterModel(
              id: 'room-1',
              chapterTitle: 'Recorded Chapter',
              chapterDescription: 'What was said',
              storyId: 's1',
            )
          : null,
      transcript: transcript,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storiesRepositoryProvider.overrideWithValue(repo),
          recordedChaptersRepositoryProvider.overrideWithValue(recordings),
          liveChapterProvider.overrideWith(() => FakeLiveChapter(state)),
          tabViewProvider.overrideWith(() => tabView),
        ],
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
  }

  Finder createButton() =>
      find.widgetWithText(ElevatedButton, 'Create Chapter');

  Future<void> tapCreate(WidgetTester tester) async {
    await tester.tap(createButton());
    await tester.pumpAndSettle();
  }

  group('opening the page', () {
    testWidgets('prefills the title and description from the live chapter', (
      tester,
    ) async {
      await mockNetworkImagesFor(() => pumpVerify(tester));

      expect(find.text('Recorded Chapter'), findsOneWidget);
      expect(find.text('What was said'), findsOneWidget);
    });

    testWidgets('names the recording it will publish', (tester) async {
      await mockNetworkImagesFor(() => pumpVerify(tester));

      expect(find.text('Audio file Selected: room-1.wav'), findsOneWidget);
    });

    // Nothing to verify without a live chapter; the page must not crash.
    testWidgets('survives having no live chapter', (tester) async {
      await mockNetworkImagesFor(() => pumpVerify(tester, withModel: false));

      expect(find.text('Verify Chapter Details'), findsOneWidget);
    });
  });

  group('while the transcript is still being made', () {
    testWidgets('says so and blocks publishing', (tester) async {
      await mockNetworkImagesFor(
        () => pumpVerify(tester, transcript: const AsyncValue.loading()),
      );

      expect(find.textContaining('Transcribing'), findsOneWidget);
      expect(tester.widget<ElevatedButton>(createButton()).onPressed, isNull);
    });

    testWidgets('a failed transcription still allows publishing', (
      tester,
    ) async {
      await mockNetworkImagesFor(
        () => pumpVerify(
          tester,
          transcript: AsyncValue.error(
            StateError('whisper died'),
            StackTrace.empty,
          ),
        ),
      );

      expect(
        tester.widget<ElevatedButton>(createButton()).onPressed,
        isNotNull,
      );
    });
  });

  group('the lyrics', () {
    testWidgets('open in a dialog for editing', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpVerify(tester);

        await tester.tap(find.text('View or Edit Lyrics'));
        await tester.pumpAndSettle();
      });

      expect(find.text('a transcript'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Close'), findsOneWidget);
    });

    testWidgets('an edit is carried into the published chapter', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpVerify(tester);

        await tester.tap(find.text('View or Edit Lyrics'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.widgetWithText(TextField, 'a transcript'),
          'corrected words',
        );
        await tester.tap(find.widgetWithText(TextButton, 'Close'));
        await tester.pumpAndSettle();

        await tapCreate(tester);
      });

      expect(repo.built?.lyrics, 'corrected words');
    });
  });

  group('publishing', () {
    testWidgets('builds the chapter and adds it to the story', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpVerify(tester);
        await tapCreate(tester);
      });

      expect(repo.built?.chapterId, 'room-1');
      expect(repo.built?.title, 'Recorded Chapter');
      expect(repo.added?.storyId, 's1');
      expect(repo.added?.chapters.single.chapterId, 'room-1');
    });

    testWidgets('writes the verified details back to the archive', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await pumpVerify(tester);
        await tester.enterText(
          find.widgetWithText(TextField, 'Recorded Chapter'),
          'Better Title',
        );
        await tapCreate(tester);
      });

      expect(recordings.updated?.id, 'room-1');
      expect(recordings.updated?.title, 'Better Title');
    });

    testWidgets('lands the author on the stories tab', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpVerify(tester);
        await tapCreate(tester);
      });

      expect(tabView.setIndexCalls, [1]);
      expect(location(), RoutePaths.tabview);
    });

    // The recording is still on the device, so the author can retry.
    testWidgets('a failure keeps the author on the page', (tester) async {
      repo.addThrows = Exception('upload failed');
      await mockNetworkImagesFor(() async {
        await pumpVerify(tester);
        await tapCreate(tester);
      });

      expect(location(), RoutePaths.verifyChapterDetails);
      expect(tabView.setIndexCalls, isEmpty);
    });

    testWidgets('an empty title publishes nothing', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpVerify(tester);
        await tester.enterText(
          find.widgetWithText(TextField, 'Recorded Chapter'),
          '',
        );
        await tapCreate(tester);
      });

      expect(repo.built, isNull);
      expect(location(), RoutePaths.verifyChapterDetails);
    });
  });
}
