import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/view/widgets/user_profile_card.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/view/widgets/participant_block.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/live_audio/data/speaking_levels.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/shared/widgets/audio_wave_ring.dart';

import '../../profile/fake_profile_repository.dart';
import '../rooms_test_helpers.dart';

List<Override> _overrides(
  AppwriteRoom room, {
  SingleRoomState? state,
  bool errorState = false,
}) {
  return [
    requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
    if (!errorState)
      roomSessionProvider(room).overrideWith(() => FakeRoomSession(state))
    else
      roomSessionProvider(room).overrideWith(() => FakeRoomSession(null)),
  ];
}

void main() {
  final room = fakeAppwriteRoom();

  // A "me" participant with admin rights so the block always renders.
  final adminMe = fakeParticipant(
    uid: 'me',
    isAdmin: true,
    isModerator: true,
    isSpeaker: true,
  );

  SingleRoomState stateWith(Participant participant, {Participant? me}) =>
      SingleRoomState(me: me ?? adminMe, participants: [participant]);

  group('me gating', () {
    testAppWidget('renders SizedBox.shrink when state.me is unavailable', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Alice Wonderland');
      // errorState makes value?.me null (AsyncError has null value).
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, errorState: true),
      );
      await tester.pumpAndSettle();

      // Nothing from the participant column should render.
      expect(find.text('Alice'), findsNothing);
      expect(find.byType(CircleAvatar), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testAppWidget('renders the participant column when me is present', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Alice Wonderland');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsWidgets);
      expect(find.text('Alice'), findsOneWidget);
    });
  });

  group('role label', () {
    testAppWidget('shows Admin for an admin participant', (tester) async {
      final participant = fakeParticipant(name: 'Bob', isAdmin: true);
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin'), findsOneWidget);
    });

    testAppWidget('shows Moderator for a moderator participant', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Bob', isModerator: true);
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Moderator'), findsOneWidget);
    });

    testAppWidget('shows Speaker for a speaker participant', (tester) async {
      final participant = fakeParticipant(name: 'Bob', isSpeaker: true);
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Speaker'), findsOneWidget);
    });

    testAppWidget('shows Listener for a plain participant', (tester) async {
      final participant = fakeParticipant(name: 'Bob');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Listener'), findsOneWidget);
    });
  });

  group('mic icon', () {
    Color micDotColor(WidgetTester tester, IconData icon) {
      final container = tester.widget<Container>(
        find
            .ancestor(of: find.byIcon(icon), matching: find.byType(Container))
            .first,
      );
      return (container.decoration as BoxDecoration).color!;
    }

    testAppWidget('shows green mic icon when speaker with mic on', (
      tester,
    ) async {
      final participant = fakeParticipant(
        name: 'Bob',
        isSpeaker: true,
        isMicOn: true,
      );
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.mic_off), findsNothing);
      final ctx = tester.element(find.byType(ParticipantBlock));
      expect(
        micDotColor(tester, Icons.mic),
        ActivityStatusColors.of(ctx).online,
      );
    });

    testAppWidget('shows red mic_off icon when speaker with mic off', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Bob', isSpeaker: true);
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_off), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      final ctx = tester.element(find.byType(ParticipantBlock));
      expect(
        micDotColor(tester, Icons.mic_off),
        Theme.of(ctx).colorScheme.error,
      );
    });

    testAppWidget('shows no mic icon when participant is not a speaker', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Bob', isMicOn: true);
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsNothing);
      expect(find.byIcon(Icons.mic_off), findsNothing);
    });
  });

  group('raise hand overlay', () {
    testAppWidget('shows waving_hand icon when hasRequestedToBeSpeaker', (
      tester,
    ) async {
      final participant = fakeParticipant(
        name: 'Bob',
        hasRequestedToBeSpeaker: true,
      );
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.waving_hand_rounded), findsOneWidget);
    });

    testAppWidget('hides waving_hand icon when not requested', (tester) async {
      final participant = fakeParticipant(name: 'Bob');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.waving_hand_rounded), findsNothing);
    });
  });

  group('speaking ring', () {
    testAppWidget('is silent by default', (tester) async {
      final participant = fakeParticipant(uid: 'bob', name: 'Bob');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(tester.widget<AudioWaveRing>(find.byType(AudioWaveRing)).level, 0);
    });

    testAppWidget('drives the ring from the participant\'s own level', (
      tester,
    ) async {
      final participant = fakeParticipant(uid: 'bob', name: 'Bob');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: [
          ..._overrides(room, state: stateWith(participant)),
          speakingLevelProvider('bob').overrideWithValue(0.8),
        ],
      );
      // Not pumpAndSettle: a speaking ring animates continuously by design.
      await tester.pump();

      expect(
        tester.widget<AudioWaveRing>(find.byType(AudioWaveRing)).level,
        0.8,
      );
    });

    testAppWidget('ignores another participant\'s level', (tester) async {
      final participant = fakeParticipant(uid: 'bob', name: 'Bob');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: [
          ..._overrides(room, state: stateWith(participant)),
          speakingLevelProvider('alice').overrideWithValue(0.8),
        ],
      );
      await tester.pumpAndSettle();

      expect(tester.widget<AudioWaveRing>(find.byType(AudioWaveRing)).level, 0);
    });
  });

  group('name', () {
    testAppWidget('shows only the first word of the name', (tester) async {
      final participant = fakeParticipant(name: 'Alice Wonderland Smith');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Alice Wonderland Smith'), findsNothing);
    });
  });

  group('profile card', () {
    // A listener: nobody they can moderate, so no role menu of their own.
    final plainMe = fakeParticipant(uid: 'me');

    testAppWidget('a long press opens the profile card', (tester) async {
      final participant = fakeParticipant(uid: 'other', name: 'Alice');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: [
          ..._overrides(room, state: stateWith(participant, me: plainMe)),
          profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
        ],
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(ParticipantBlock));
      await tester.pumpAndSettle();

      expect(find.byType(UserProfileCard), findsOneWidget);
    });

    testAppWidget('the card wins the long press over the role menu', (
      tester,
    ) async {
      final participant = fakeParticipant(uid: 'other', name: 'Alice');
      // adminMe can moderate this participant, so the block also holds a menu.
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: [
          ..._overrides(room, state: stateWith(participant)),
          profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
        ],
      );
      await tester.pumpAndSettle();

      await tester.longPress(find.byType(ParticipantBlock));
      await tester.pumpAndSettle();

      expect(find.byType(UserProfileCard), findsOneWidget);
      expect(find.text('Kick Out'), findsNothing);
    });

    testAppWidget('a viewer with no menu is left with only the card', (
      tester,
    ) async {
      final participant = fakeParticipant(uid: 'other', name: 'Alice');
      await pumpTestApp(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: [
          ..._overrides(room, state: stateWith(participant, me: plainMe)),
          profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
        ],
      );
      await tester.pumpAndSettle();

      // A tap used to open focused_menu with an empty item list.
      await tester.tap(find.byType(ParticipantBlock));
      await tester.pumpAndSettle();

      expect(find.byType(UserProfileCard), findsNothing);
      expect(find.text('Kick Out'), findsNothing);
    });
  });

  group('role menu', () {
    testAppWidget('fits a narrow screen with a large font setting', (
      tester,
    ) async {
      final participant = fakeParticipant(uid: 'other', name: 'Alice');
      tester.view.physicalSize = const Size(720, 1600);
      tester.view.devicePixelRatio = 3.0;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await pumpTestApp(
        tester,
        Center(child: ParticipantBlock(room: room, participant: participant)),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      // An admin opens the role menu with a tap.
      await tester.tap(find.byType(ParticipantBlock));
      await tester.pumpAndSettle();

      expect(find.text('Kick Out'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
