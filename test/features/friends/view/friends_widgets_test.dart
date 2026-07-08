import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/friends/view/widgets/call_control_panel.dart';
import 'package:resonate/features/friends/view/widgets/friends_empty_view.dart';
import 'package:resonate/features/shell/viewmodel/tabview_notifier.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';

import '../friends_test_helpers.dart';

GoRouter recordingRouter(List<String> log) => GoRouter(
  initialLocation: RoutePaths.tabview,
  routes: [
    GoRoute(
      path: RoutePaths.tabview,
      builder: (context, state) {
        log.add(state.uri.path);
        return const SizedBox.shrink();
      },
    ),
  ],
);

void main() {
  group('FriendsEmptyView', () {
    testFriendsWidget('shows friends-empty copy when not requests screen', (
      tester,
    ) async {
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: false),
        overrides: [tabViewProvider.overrideWith(FakeTabView.new)],
      );
      await tester.pumpAndSettle();

      expect(find.text('No Friends Yet'), findsOneWidget);
      expect(find.text('No Friend Requests'), findsNothing);
      expect(find.byIcon(Icons.people_outline_rounded), findsOneWidget);
    });

    testFriendsWidget('shows requests-empty copy when requests screen', (
      tester,
    ) async {
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: true),
        overrides: [tabViewProvider.overrideWith(FakeTabView.new)],
      );
      await tester.pumpAndSettle();

      expect(find.text('No Friend Requests'), findsOneWidget);
      expect(find.text('No Friends Yet'), findsNothing);
      expect(find.byIcon(Icons.person_add_outlined), findsWidgets);
    });

    testFriendsWidget('Find Friends button sets tab index to 1', (
      tester,
    ) async {
      final fake = FakeTabView();
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: false),
        overrides: [
          tabViewProvider.overrideWith(() => fake),
          routerProvider.overrideWithValue(recordingRouter(<String>[])),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text('Find Friends'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(fake.setIndexCalls, [1]);
    });

    testFriendsWidget('Invite button exists and tapping does not throw', (
      tester,
    ) async {
      await pumpFriendsPage(
        tester,
        const FriendsEmptyView(isRequestsScreen: false),
        overrides: [tabViewProvider.overrideWith(FakeTabView.new)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Invite a Friend'), findsOneWidget);
      // Invite is the only person_add_outlined icon on the friends-empty view.
      final invite = find.byIcon(Icons.person_add_outlined);
      expect(invite, findsOneWidget);
      // SharePlus is a native side-effect; just ensure the tap doesn't throw.
      await tester.tap(invite);
      await tester.pump();
    });
  });

  group('CallControlPanel', () {
    // Convenience builder with recording callbacks.
    Widget panel({
      required bool isMicOn,
      required bool isLoudSpeakerOn,
      VoidCallback? onToggleMic,
      VoidCallback? onToggleLoudSpeaker,
      VoidCallback? onAudioSettings,
      VoidCallback? onEnd,
    }) => CallControlPanel(
      isMicOn: isMicOn,
      isLoudSpeakerOn: isLoudSpeakerOn,
      onToggleMic: onToggleMic ?? () {},
      onToggleLoudSpeaker: onToggleLoudSpeaker ?? () {},
      onAudioSettings: onAudioSettings ?? () {},
      onEnd: onEnd ?? () {},
    );

    Future<void> pumpPanel(WidgetTester tester, Widget child) async {
      tester.view.physicalSize = const Size(2400, 1200);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          child: friendsTestApp(child),
        ),
      );
    }

    testFriendsWidget('shows the mic icon when the mic is on', (tester) async {
      await pumpPanel(tester, panel(isMicOn: true, isLoudSpeakerOn: false));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.mic_off), findsNothing);
    });

    testFriendsWidget('shows the mic_off icon when the mic is off', (
      tester,
    ) async {
      await pumpPanel(tester, panel(isMicOn: false, isLoudSpeakerOn: false));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_off), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
    });

    testFriendsWidget('speaker button color reflects isLoudSpeakerOn', (
      tester,
    ) async {
      // On: uses colorScheme.primary. Off: uses the inactive color.
      await pumpPanel(tester, panel(isMicOn: true, isLoudSpeakerOn: true));
      await tester.pumpAndSettle();

      final scheme = Theme.of(
        tester.element(find.byType(CallControlPanel)),
      ).colorScheme;
      final speakerFab = tester.widget<FloatingActionButton>(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == 'speaker',
        ),
      );
      expect(speakerFab.backgroundColor, scheme.primary);
    });

    testFriendsWidget('speaker button uses inactive color when off', (
      tester,
    ) async {
      await pumpPanel(tester, panel(isMicOn: true, isLoudSpeakerOn: false));
      await tester.pumpAndSettle();

      final scheme = Theme.of(
        tester.element(find.byType(CallControlPanel)),
      ).colorScheme;
      final speakerFab = tester.widget<FloatingActionButton>(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == 'speaker',
        ),
      );
      expect(speakerFab.backgroundColor, isNot(scheme.primary));
    });

    testFriendsWidget('End button uses the error color', (tester) async {
      await pumpPanel(tester, panel(isMicOn: true, isLoudSpeakerOn: false));
      await tester.pumpAndSettle();

      final scheme = Theme.of(
        tester.element(find.byType(CallControlPanel)),
      ).colorScheme;
      final endFab = tester.widget<FloatingActionButton>(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == 'end-chat',
        ),
      );
      expect(endFab.backgroundColor, scheme.error);
    });

    testFriendsWidget('each control button invokes its callback', (
      tester,
    ) async {
      var mic = 0, speaker = 0, audio = 0, end = 0;
      await pumpPanel(
        tester,
        panel(
          isMicOn: true,
          isLoudSpeakerOn: false,
          onToggleMic: () => mic++,
          onToggleLoudSpeaker: () => speaker++,
          onAudioSettings: () => audio++,
          onEnd: () => end++,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == 'mic',
        ),
      );
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == 'speaker',
        ),
      );
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == 'audio-settings',
        ),
      );
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is FloatingActionButton && w.heroTag == 'end-chat',
        ),
      );
      await tester.pumpAndSettle();

      expect(mic, 1);
      expect(speaker, 1);
      expect(audio, 1);
      expect(end, 1);
    });
  });
}
