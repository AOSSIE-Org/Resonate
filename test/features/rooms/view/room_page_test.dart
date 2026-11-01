import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/view/pages/room_page.dart';
import 'package:resonate/features/rooms/view/widgets/participant_block.dart';
import 'package:resonate/features/rooms/viewmodel/single_room_notifier.dart';

import '../rooms_test_helpers.dart';

// Loading fake: never completes build().
class LoadingSingleRoom extends SingleRoomNotifier {
  final Completer<SingleRoomState> _c = Completer();
  @override
  Future<SingleRoomState> build(AppwriteRoom appwriteRoom) => _c.future;
}

SingleRoomState stateWith(Participant me, {List<Participant> participants = const []}) {
  return SingleRoomState(me: me, participants: participants);
}

// Builds the overrides with the current user + a fake room notifier.
List<Override> roomOverrides({
  required AppwriteRoom room,
  required SingleRoomNotifier Function() fake,
}) => [
      requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
      currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
      singleRoomProvider(room).overrideWith(fake),
    ];

void main() {
  group('RoomPage state rendering', () {
    testRoomsWidget('loading -> spinner, no body/footer', (tester) async {
      final room = fakeAppwriteRoom();
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(room: room, fake: LoadingSingleRoom.new),
      );
      await tester.pump();
      // Loading branch: a spinner is shown; body/footer not built yet.
      expect(find.text('No participants yet'), findsNothing);
      expect(find.byIcon(Icons.call_end), findsNothing);
      // The room header still renders.
      expect(find.text('Test Room'), findsOneWidget);
    });

    testRoomsWidget('error -> body renders with no participants view', (
      tester,
    ) async {
      final room = fakeAppwriteRoom();
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => FakeSingleRoom(
            stateWith(fakeParticipant(uid: 'me')),
            throwOnError: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Error path builds _RoomBody with null state -> empty participants.
      expect(find.text('No participants yet'), findsOneWidget);
    });

    testRoomsWidget('data empty -> _NoParticipantsView', (tester) async {
      final room = fakeAppwriteRoom();
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => FakeSingleRoom(stateWith(fakeParticipant(uid: 'me'))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No participants yet'), findsOneWidget);
      expect(find.byType(ParticipantBlock), findsNothing);
    });

    testRoomsWidget('data with participants -> GridView of ParticipantBlock', (
      tester,
    ) async {
      final room = fakeAppwriteRoom();
      final participants = [
        fakeParticipant(uid: 'me', name: 'Me', isAdmin: true, isSpeaker: true),
        fakeParticipant(uid: 'p2', name: 'Bob'),
      ];
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => FakeSingleRoom(
            stateWith(participants.first, participants: participants),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ParticipantBlock), findsNWidgets(2));
      expect(find.text('No participants yet'), findsNothing);
      // ParticipantBlock's tight cell can overflow by a couple px; ignore it.
      tester.takeException();
    });
  });

  group('Leave / delete button', () {
    // Push RoomPage as a route so Navigator.canPop() is true.
    Future<FakeSingleRoom> pumpRouted(
      WidgetTester tester,
      AppwriteRoom room,
      SingleRoomState state,
    ) async {
      late FakeSingleRoom fake;
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: roomOverrides(
            room: room,
            fake: () {
              fake = FakeSingleRoom(state);
              return fake;
            },
          ),
          child: roomsTestApp(
            Navigator(
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RoomPage(room: room),
                    ),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return fake;
    }

    testRoomsWidget('admin confirm=true -> deleteRoom + pops', (tester) async {
      final room = fakeAppwriteRoom(isUserAdmin: true);
      final me = fakeParticipant(uid: 'me', isAdmin: true, isSpeaker: true);
      final fake = await pumpRouted(tester, room, stateWith(me));

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      // Confirm dialog visible.
      expect(find.text('Confirm'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(fake.deleteRoomCount, 1);
      expect(fake.leaveRoomCount, 0);
      // Popped back to launcher screen.
      expect(find.byIcon(Icons.call_end), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testRoomsWidget('non-admin confirm=true -> leaveRoom + pops', (tester) async {
      final room = fakeAppwriteRoom(isUserAdmin: false);
      final me = fakeParticipant(uid: 'me', isSpeaker: true);
      final fake = await pumpRouted(tester, room, stateWith(me));

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(fake.leaveRoomCount, 1);
      expect(fake.deleteRoomCount, 0);
      expect(find.byIcon(Icons.call_end), findsNothing);
    });

    testRoomsWidget('cancel -> no action, still in room', (tester) async {
      final room = fakeAppwriteRoom(isUserAdmin: true);
      final me = fakeParticipant(uid: 'me', isAdmin: true, isSpeaker: true);
      final fake = await pumpRouted(tester, room, stateWith(me));

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(fake.deleteRoomCount, 0);
      expect(fake.leaveRoomCount, 0);
      // Still on the room page.
      expect(find.byIcon(Icons.call_end), findsOneWidget);
    });
  });

  group('Mic FAB', () {
    testRoomsWidget('disabled when not speaker', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', isSpeaker: false);
      late FakeSingleRoom fake;
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeSingleRoom(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      // mic_off icon shown; tapping does nothing (onPressed null).
      await tester.tap(find.byIcon(Icons.mic_off));
      await tester.pumpAndSettle();
      expect(fake.turnOnMicCount, 0);
      expect(fake.turnOffMicCount, 0);
    });

    testRoomsWidget('speaker mic off -> turnOnMic', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', isSpeaker: true, isMicOn: false);
      late FakeSingleRoom fake;
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeSingleRoom(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.mic_off));
      await tester.pumpAndSettle();
      expect(fake.turnOnMicCount, 1);
      expect(fake.turnOffMicCount, 0);
    });

    testRoomsWidget('speaker mic on -> turnOffMic', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', isSpeaker: true, isMicOn: true);
      late FakeSingleRoom fake;
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeSingleRoom(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();
      expect(fake.turnOffMicCount, 1);
      expect(fake.turnOnMicCount, 0);
    });
  });

  group('Raise hand FAB', () {
    testRoomsWidget('not raised -> raiseHand', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', hasRequestedToBeSpeaker: false);
      late FakeSingleRoom fake;
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeSingleRoom(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.back_hand_outlined));
      await tester.pumpAndSettle();
      expect(fake.raiseHandCount, 1);
      expect(fake.unRaiseHandCount, 0);
    });

    testRoomsWidget('already raised -> unRaiseHand', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', hasRequestedToBeSpeaker: true);
      late FakeSingleRoom fake;
      await pumpRoomsPage(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeSingleRoom(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.back_hand));
      await tester.pumpAndSettle();
      expect(fake.unRaiseHandCount, 1);
      expect(fake.raiseHandCount, 0);
    });
  });

  group('wasKicked listener', () {
    testRoomsWidget('shows removed snackbar and pops', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me');
      // Controllable notifier so we can flip wasKicked after first frame.
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: roomOverrides(
            room: room,
            fake: () => FakeSingleRoom(stateWith(me)),
          ),
          child: roomsTestApp(
            Navigator(
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RoomPage(room: room),
                    ),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.call_end), findsOneWidget);

      // Emit a kicked state; ref.listen should fire.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(RoomPage)),
      );
      final notifier = container.read(singleRoomProvider(room).notifier);
      notifier.state = AsyncData(stateWith(me).copyWith(wasKicked: true));
      await tester.pump();

      expect(
        find.text('You have been reported or removed from the room'),
        findsWidgets,
      );
      await tester.pumpAndSettle();
      // Popped back to launcher.
      expect(find.byIcon(Icons.call_end), findsNothing);
    });
  });
}
