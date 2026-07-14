import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/view/widgets/participant_block.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';
import 'package:resonate/features/rooms/viewmodel/single_room_notifier.dart';

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
      singleRoomProvider(room).overrideWith(() => FakeSingleRoom(state))
    else
      singleRoomProvider(room).overrideWith(() => FakeSingleRoom(null)),
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
    testRoomsWidget('renders SizedBox.shrink when state.me is unavailable', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Alice Wonderland');
      // errorState makes value?.me null (AsyncError has null value).
      await pumpRoomsPage(
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

    testRoomsWidget('renders the participant column when me is present', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Alice Wonderland');
      await pumpRoomsPage(
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
    testRoomsWidget('shows Admin for an admin participant', (tester) async {
      final participant = fakeParticipant(name: 'Bob', isAdmin: true);
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Admin'), findsOneWidget);
    });

    testRoomsWidget('shows Moderator for a moderator participant', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Bob', isModerator: true);
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Moderator'), findsOneWidget);
    });

    testRoomsWidget('shows Speaker for a speaker participant', (tester) async {
      final participant = fakeParticipant(name: 'Bob', isSpeaker: true);
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Speaker'), findsOneWidget);
    });

    testRoomsWidget('shows Listener for a plain participant', (tester) async {
      final participant = fakeParticipant(name: 'Bob');
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Listener'), findsOneWidget);
    });
  });

  group('mic icon', () {
    testRoomsWidget('shows green mic icon when speaker with mic on', (
      tester,
    ) async {
      final participant = fakeParticipant(
        name: 'Bob',
        isSpeaker: true,
        isMicOn: true,
      );
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.mic_off), findsNothing);
      final icon = tester.widget<Icon>(find.byIcon(Icons.mic));
      expect(icon.color, Colors.lightGreen);
    });

    testRoomsWidget('shows red mic_off icon when speaker with mic off', (
      tester,
    ) async {
      final participant = fakeParticipant(
        name: 'Bob',
        isSpeaker: true,
      );
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic_off), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
      final icon = tester.widget<Icon>(find.byIcon(Icons.mic_off));
      expect(icon.color, Colors.red);
    });

    testRoomsWidget('shows no mic icon when participant is not a speaker', (
      tester,
    ) async {
      final participant = fakeParticipant(name: 'Bob', isMicOn: true);
      await pumpRoomsPage(
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
    testRoomsWidget('shows waving_hand icon when hasRequestedToBeSpeaker', (
      tester,
    ) async {
      final participant = fakeParticipant(
        name: 'Bob',
        hasRequestedToBeSpeaker: true,
      );
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.waving_hand_rounded), findsOneWidget);
    });

    testRoomsWidget('hides waving_hand icon when not requested', (tester) async {
      final participant = fakeParticipant(name: 'Bob');
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.waving_hand_rounded), findsNothing);
    });
  });

  group('name', () {
    testRoomsWidget('shows only the first word of the name', (tester) async {
      final participant = fakeParticipant(name: 'Alice Wonderland Smith');
      await pumpRoomsPage(
        tester,
        ParticipantBlock(room: room, participant: participant),
        overrides: _overrides(room, state: stateWith(participant)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Alice Wonderland Smith'), findsNothing);
    });
  });
}
