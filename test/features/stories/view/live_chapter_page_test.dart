import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/model/live_chapter_state.dart';
import 'package:resonate/features/stories/view/pages/live_chapter_page.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_attendee_block.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/shared/widgets/session_app_bar.dart';
import 'package:resonate/shared/widgets/session_control_bar.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/utils/ui_sizes.dart';

import 'stories_test_helpers.dart';


Future<void> pumpLiveChapterPage(
  WidgetTester tester, {
  required List<Override> overrides,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: RoutePaths.liveChapterScreen,
    routes: [
      GoRoute(
        path: RoutePaths.liveChapterScreen,
        builder: (context, _) {
          UiSizes.init(context);
          return const LiveChapterPage();
        },
      ),
      GoRoute(
        path: RoutePaths.verifyChapterDetails,
        builder: (_, _) => const SizedBox.shrink(),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...avatarOverrides(),
        ...achievementOverrides(),
        ...overrides,
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
      ),
    ),
  );
}

LiveChapterAttendee attendee(String id, String name) =>
    LiveChapterAttendee(id: id, name: name, profileImageUrl: '');

List<Override> liveChapterOverrides({
  required String viewerUid,
  String authorUid = 'author',
  List<LiveChapterAttendee> attendees = const [],
  bool isMicOn = false,
}) => [
  currentUserProvider.overrideWithValue(fakeAuthUser(uid: viewerUid)),
  requireUserProvider.overrideWithValue(fakeAuthUser(uid: viewerUid)),
  liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
  liveChapterProvider.overrideWith(
    () => FakeLiveChapter(
      LiveChapterState(
        isMicOn: isMicOn,
        model: fakeLiveChapterModel(
          authorUid: authorUid,
          chapterTitle: 'Night Shift',
          attendees: LiveChapterAttendeesModel(
            liveChapterId: 'room-1',
            users: attendees,
            userIds: [for (final user in attendees) user.id],
          ),
        ),
      ),
    ),
  ),
];

Finder control(SessionControlKind kind) =>
    find.byKey(ValueKey('session-control-${kind.name}'));

void main() {
  testStoryWidget('lays the chapter out like a room: header, stage, pill', (
    tester,
  ) async {
    await pumpLiveChapterPage(
      tester,
      overrides: liveChapterOverrides(viewerUid: 'author'),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SessionAppBar), findsOneWidget);
    expect(find.byType(SessionHeader), findsOneWidget);
    expect(find.text('Night Shift'), findsOneWidget);
    expect(find.byType(SessionControlBar), findsOneWidget);
  });

  testStoryWidget('features the author and grids the listeners', (
    tester,
  ) async {
    await pumpLiveChapterPage(
      tester,
      overrides: liveChapterOverrides(
        viewerUid: 'author',
        attendees: [attendee('u2', 'Bob Jones'), attendee('u3', 'Cara Diaz')],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LiveChapterAttendeeBlock), findsNWidgets(3));
    final featured = tester
        .widgetList<LiveChapterAttendeeBlock>(
          find.byType(LiveChapterAttendeeBlock),
        )
        .where((block) => block.featured)
        .toList();
    expect(featured, hasLength(1));
    expect(featured.single.user.id, 'author');
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Cara'), findsOneWidget);
  });

  testStoryWidget('never draws the author twice', (tester) async {
    await pumpLiveChapterPage(
      tester,
      overrides: liveChapterOverrides(
        viewerUid: 'author',
        // A re-join can write the author into the attendee row.
        attendees: [attendee('author', 'Ann Author')],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LiveChapterAttendeeBlock), findsOneWidget);
    expect(find.text('No listeners yet'), findsOneWidget);
  });

  testStoryWidget('the author gets mic and record controls', (tester) async {
    await pumpLiveChapterPage(
      tester,
      overrides: liveChapterOverrides(viewerUid: 'author'),
    );
    await tester.pumpAndSettle();

    expect(control(SessionControlKind.leave), findsOneWidget);
    expect(control(SessionControlKind.mic), findsOneWidget);
    expect(control(SessionControlKind.record), findsOneWidget);
    expect(control(SessionControlKind.audioDevice), findsOneWidget);
  });

  testStoryWidget('a listener gets neither mic nor record', (tester) async {
    await pumpLiveChapterPage(
      tester,
      overrides: liveChapterOverrides(
        viewerUid: 'u2',
        attendees: [attendee('u2', 'Bob Jones')],
      ),
    );
    await tester.pumpAndSettle();

    expect(control(SessionControlKind.leave), findsOneWidget);
    expect(control(SessionControlKind.audioDevice), findsOneWidget);
    expect(control(SessionControlKind.record), findsNothing);
    expect(control(SessionControlKind.mic), findsNothing);
  });

  testStoryWidget('the back arrow confirms rather than stranding the session', (
    tester,
  ) async {
    await pumpLiveChapterPage(
      tester,
      overrides: liveChapterOverrides(viewerUid: 'author'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsOneWidget);
    expect(find.byType(LiveChapterPage), findsOneWidget);
  });
}
