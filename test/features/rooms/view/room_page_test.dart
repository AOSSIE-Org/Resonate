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
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';

import '../rooms_test_helpers.dart';

class SlowTeardownLauncher extends FakeRoomLauncher {
  final Completer<void> gate = Completer<void>();

  @override
  Future<void> leave(AppwriteRoom room) {
    leaveCount++;
    lastLeft = room;
    return gate.future;
  }
}

// Loading fake: never completes build().
class LoadingSingleRoom extends RoomSession {
  final Completer<SingleRoomState> _c = Completer();
  @override
  Future<SingleRoomState> build(AppwriteRoom appwriteRoom) => _c.future;
}

SingleRoomState stateWith(
  Participant me, {
  List<Participant> participants = const [],
}) {
  return SingleRoomState(me: me, participants: participants);
}

// Builds the overrides with the current user + a fake room notifier.
List<Override> roomOverrides({
  required AppwriteRoom room,
  required RoomSession Function() fake,
  RoomLauncher? launcher,
}) => [
  requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  roomSessionProvider(room).overrideWith(fake),
  if (launcher != null) roomLauncherProvider.overrideWithValue(launcher),
];

void main() {
  group('RoomPage state rendering', () {
    testAppWidget('loading -> spinner, no body/footer', (tester) async {
      final room = fakeAppwriteRoom();
      await pumpTestApp(
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

    testAppWidget('error -> body renders with no participants view', (
      tester,
    ) async {
      final room = fakeAppwriteRoom();
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => FakeRoomSession(
            stateWith(fakeParticipant(uid: 'me')),
            throwOnError: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Error path builds _RoomBody with null state -> empty participants.
      expect(find.text('No participants yet'), findsOneWidget);
    });

    testAppWidget('data empty -> _NoParticipantsView', (tester) async {
      final room = fakeAppwriteRoom();
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => FakeRoomSession(stateWith(fakeParticipant(uid: 'me'))),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No participants yet'), findsOneWidget);
      expect(find.byType(ParticipantBlock), findsNothing);
    });

    testAppWidget('data with participants -> host card + listener grid', (
      tester,
    ) async {
      final room = fakeAppwriteRoom();
      final participants = [
        fakeParticipant(uid: 'me', name: 'Me', isAdmin: true, isSpeaker: true),
        fakeParticipant(uid: 'p2', name: 'Bob'),
      ];
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => FakeRoomSession(
            stateWith(participants.first, participants: participants),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SliverGrid), findsOneWidget);
      // The admin gets the featured card, the listener a grid tile.
      final blocks = tester
          .widgetList<ParticipantBlock>(find.byType(ParticipantBlock))
          .toList();
      expect(blocks.length, 2);
      expect(blocks.first.featured, isTrue);
      expect(blocks.last.featured, isFalse);
      expect(find.text('No participants yet'), findsNothing);
    });

    testAppWidget('the grid survives a large font setting', (tester) async {
      final room = fakeAppwriteRoom();
      final participants = [
        fakeParticipant(uid: 'me', isAdmin: true, isModerator: true, isSpeaker: true),
        fakeParticipant(uid: 'a', name: 'Alice', isModerator: true, isSpeaker: true),
        fakeParticipant(uid: 'b', name: 'Bob', isSpeaker: true),
        fakeParticipant(uid: 'c', name: 'Carol'),
      ];

      tester.view.physicalSize = const Size(720, 1600);
      tester.view.devicePixelRatio = 3.0;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => FakeRoomSession(
            stateWith(participants.first, participants: participants),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('Leave / delete button', () {
    // Push RoomPage as a route so Navigator.canPop() is true.
    Future<FakeRoomLauncher> pumpRouted(
      WidgetTester tester,
      AppwriteRoom room,
      SingleRoomState state, {
      FakeRoomLauncher? launcher,
    }) async {
      final fake = launcher ?? FakeRoomLauncher();
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: roomOverrides(
            room: room,
            fake: () => FakeRoomSession(state),
            launcher: fake,
          ),
          child: testApp(
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

    testAppWidget('admin confirm=true -> leave + pops', (tester) async {
      final room = fakeAppwriteRoom(isUserAdmin: true);
      final me = fakeParticipant(uid: 'me', isAdmin: true, isSpeaker: true);
      final fake = await pumpRouted(tester, room, stateWith(me));

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      // Confirm dialog visible.
      expect(find.text('Confirm'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // The view just asks to leave; the launcher decides that a host
      // leaving ends the room.
      expect(fake.leaveCount, 1);
      expect(fake.lastLeft?.isUserAdmin, isTrue);
      // Popped back to launcher screen.
      expect(find.byIcon(Icons.call_end), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testAppWidget('non-admin confirm=true -> leave + pops', (tester) async {
      final room = fakeAppwriteRoom(isUserAdmin: false);
      final me = fakeParticipant(uid: 'me', isSpeaker: true);
      final fake = await pumpRouted(tester, room, stateWith(me));

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(fake.leaveCount, 1);
      expect(fake.lastLeft?.isUserAdmin, isFalse);
      expect(find.byIcon(Icons.call_end), findsNothing);
    });

    testAppWidget('cancel -> no action, still in room', (tester) async {
      final room = fakeAppwriteRoom(isUserAdmin: true);
      final me = fakeParticipant(uid: 'me', isAdmin: true, isSpeaker: true);
      final fake = await pumpRouted(tester, room, stateWith(me));

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(fake.leaveCount, 0);
      // Still on the room page.
      expect(find.byIcon(Icons.call_end), findsOneWidget);
    });

    testAppWidget('back button closes the sheet without ending the room', (
      tester,
    ) async {
      final room = fakeAppwriteRoom(isUserAdmin: true);
      final me = fakeParticipant(uid: 'me', isAdmin: true, isSpeaker: true);
      final fake = await pumpRouted(tester, room, stateWith(me));

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // No confirmation, no teardown — just gone from view.
      expect(find.text('Confirm'), findsNothing);
      expect(fake.leaveCount, 0);
      expect(find.byIcon(Icons.call_end), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testAppWidget('admin pops without waiting for the delete to finish', (
      tester,
    ) async {
      final room = fakeAppwriteRoom(isUserAdmin: true);
      final me = fakeParticipant(uid: 'me', isAdmin: true, isSpeaker: true);
      final slow = SlowTeardownLauncher();
      await pumpRouted(tester, room, stateWith(me), launcher: slow);

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(slow.leaveCount, 1);
      // Teardown is still in flight, but the room page is already gone.
      expect(slow.gate.isCompleted, isFalse);
      expect(find.byIcon(Icons.call_end), findsNothing);
      expect(find.text('open'), findsOneWidget);
      slow.gate.complete();
    });

    testAppWidget('participant pops without waiting for the leave to finish', (
      tester,
    ) async {
      final room = fakeAppwriteRoom(isUserAdmin: false);
      final me = fakeParticipant(uid: 'me', isSpeaker: true);
      final slow = SlowTeardownLauncher();
      await pumpRouted(tester, room, stateWith(me), launcher: slow);

      await tester.tap(find.byIcon(Icons.call_end));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(slow.leaveCount, 1);
      expect(slow.gate.isCompleted, isFalse);
      expect(find.byIcon(Icons.call_end), findsNothing);
      expect(find.text('open'), findsOneWidget);
      slow.gate.complete();
    });
  });

  group('Mic FAB', () {
    testAppWidget('disabled when not speaker', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', isSpeaker: false);
      late FakeRoomSession fake;
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeRoomSession(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      // mic_off icon shown; tapping does nothing (onPressed null).
      await tester.tap(find.byIcon(Icons.mic_off));
      await tester.pumpAndSettle();
      expect(fake.turnOnMicCount, 0);
      expect(fake.turnOffMicCount, 0);
    });

    testAppWidget('speaker mic off -> turnOnMic', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', isSpeaker: true, isMicOn: false);
      late FakeRoomSession fake;
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeRoomSession(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.mic_off));
      await tester.pumpAndSettle();
      expect(fake.turnOnMicCount, 1);
      expect(fake.turnOffMicCount, 0);
    });

    testAppWidget('speaker mic on -> turnOffMic', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', isSpeaker: true, isMicOn: true);
      late FakeRoomSession fake;
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeRoomSession(stateWith(me)),
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
    testAppWidget('not raised -> raiseHand', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', hasRequestedToBeSpeaker: false);
      late FakeRoomSession fake;
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeRoomSession(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.back_hand_outlined));
      await tester.pumpAndSettle();
      expect(fake.raiseHandCount, 1);
      expect(fake.unRaiseHandCount, 0);
    });

    testAppWidget('already raised -> unRaiseHand', (tester) async {
      final room = fakeAppwriteRoom();
      final me = fakeParticipant(uid: 'me', hasRequestedToBeSpeaker: true);
      late FakeRoomSession fake;
      await pumpTestApp(
        tester,
        RoomPage(room: room),
        overrides: roomOverrides(
          room: room,
          fake: () => fake = FakeRoomSession(stateWith(me)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.back_hand));
      await tester.pumpAndSettle();
      expect(fake.unRaiseHandCount, 1);
      expect(fake.raiseHandCount, 0);
    });
  });

  group('departure listener', () {
    final room = fakeAppwriteRoom();
    final me = fakeParticipant(uid: 'me');

    // Opens the room on a route that can be popped, with the real root
    // navigator attached so customSnackbar's overlay has somewhere to go.
    Future<RoomSession> openRoom(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          // Controllable notifier so we can flip the flags after first frame.
          overrides: roomOverrides(
            room: room,
            fake: () => FakeRoomSession(stateWith(me)),
          ),
          child: testApp(
            rootOverlay: true,
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

      final container = ProviderScope.containerOf(
        tester.element(find.byType(RoomPage)),
      );
      return container.read(roomSessionProvider(room).notifier);
    }

    // Lets the toast time out so no timer outlives the test, then settles.
    Future<void> settle(WidgetTester tester) async {
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    }

    testAppWidget('shows removed snackbar and pops', (tester) async {
      final notifier = await openRoom(tester);

      notifier.state = AsyncData(stateWith(me).copyWith(wasKicked: true));
      await tester.pump();

      expect(
        find.text('You have been reported or removed from the room'),
        findsWidgets,
      );
      await settle(tester);
      // Popped back to launcher.
      expect(find.byIcon(Icons.call_end), findsNothing);
    });

    testAppWidget('shows the room ended snackbar and pops', (tester) async {
      final notifier = await openRoom(tester);

      notifier.state = AsyncData(stateWith(me).copyWith(roomEnded: true));
      await tester.pump();

      expect(find.text('This room has ended'), findsWidgets);
      expect(
        find.text('You have been reported or removed from the room'),
        findsNothing,
      );
      await settle(tester);
      expect(find.byIcon(Icons.call_end), findsNothing);
    });
  });
}
