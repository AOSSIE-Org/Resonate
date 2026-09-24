import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/miniplayer/model/miniplayer_session.dart';
import 'package:resonate/features/miniplayer/view/widgets/session_miniplayer.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/shared/widgets/speaking_profile_avatar.dart';

import '../friends/friends_test_helpers.dart';

void main() {
  final room = fakeAppwriteRoom(name: 'Test Room');

  MiniplayerSession roomSession({
    bool isMicOn = false,
    bool canToggleMic = true,
  }) => MiniplayerSession(
    speakerUid: 'speaker',
    avatarUrl: 'https://example.com/speaker.jpg',
    isMicOn: isMicOn,
    canToggleMic: canToggleMic,
    title: room.name,
    room: room,
  );

  const callSession = MiniplayerSession(
    speakerUid: 'friend',
    avatarUrl: 'https://example.com/friend.jpg',
    isMicOn: true,
    canToggleMic: true,
  );

  final taps = <String, int>{};

  Future<void> pumpPlayer(
    WidgetTester tester,
    MiniplayerSession session, {
    bool pip = false,
  }) async {
    taps.clear();
    void record(String action) => taps[action] = (taps[action] ?? 0) + 1;
    await pumpFriendsPage(
      tester,
      pip
          ? SessionMiniplayer.pip(session: session)
          : SessionMiniplayer(
              session: session,
              onRestore: () => record('restore'),
              onToggleMic: () => record('mic'),
              onLeave: () => record('leave'),
            ),
      overrides: [
        userProfileImagePlaceholderUrlProvider.overrideWithValue(
          'https://example.com/placeholder.png',
        ),
      ],
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a room shows its name next to the speaking avatar', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await pumpPlayer(tester, roomSession());

      expect(find.text('Test Room'), findsOneWidget);
      final avatar = tester.widget<SpeakingProfileAvatar>(
        find.byType(SpeakingProfileAvatar),
      );
      expect(avatar.uid, 'speaker');
    });
  });

  testWidgets('a call shows the friend alone, with no title', (tester) async {
    await mockNetworkImagesFor(() async {
      await pumpPlayer(tester, callSession);

      expect(find.byType(Text), findsNothing);
      final avatar = tester.widget<SpeakingProfileAvatar>(
        find.byType(SpeakingProfileAvatar),
      );
      expect(avatar.uid, 'friend');
    });
  });

  testWidgets('tapping the bar restores the full screen', (tester) async {
    await mockNetworkImagesFor(() async {
      await pumpPlayer(tester, roomSession());

      await tester.tap(find.text('Test Room'));
      await tester.pump();
      expect(taps['restore'], 1);
    });
  });

  testWidgets('leaving is a separate control from restoring', (tester) async {
    await mockNetworkImagesFor(() async {
      await pumpPlayer(tester, roomSession());

      await tester.tap(find.byKey(const ValueKey('miniplayer-leave')));
      await tester.pump();
      expect(taps['leave'], 1);
      expect(taps['restore'], isNull);
    });
  });

  testWidgets('the mic control reports the mic state and routes taps', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await pumpPlayer(tester, roomSession(isMicOn: true));
      expect(find.byIcon(Icons.mic), findsOneWidget);

      await pumpPlayer(tester, roomSession());
      expect(find.byIcon(Icons.mic_off), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('miniplayer-mic')));
      await tester.pump();
      expect(taps['mic'], 1);
      expect(taps['restore'], isNull);
    });
  });

  testWidgets('a listener gets a dimmed, dead mic control', (tester) async {
    await mockNetworkImagesFor(() async {
      await pumpPlayer(tester, roomSession(canToggleMic: false));

      final button = tester.widget<InkWell>(
        find.descendant(
          of: find.byKey(const ValueKey('miniplayer-mic')),
          matching: find.byType(InkWell),
        ),
      );
      expect(button.onTap, isNull);
    });
  });

  testWidgets('the PiP window is display-only: it cannot receive taps', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await pumpPlayer(tester, roomSession(), pip: true);

      expect(find.text('Test Room'), findsOneWidget);
      expect(find.byType(SpeakingProfileAvatar), findsOneWidget);
      expect(find.byKey(const ValueKey('miniplayer-mic')), findsNothing);
      expect(find.byKey(const ValueKey('miniplayer-leave')), findsNothing);
    });
  });
}
