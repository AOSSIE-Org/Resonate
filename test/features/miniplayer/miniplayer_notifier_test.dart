import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/friends/model/friend_call_state.dart';
import 'package:resonate/features/live_audio/data/speaking_levels.dart';
import 'package:resonate/features/miniplayer/viewmodel/miniplayer_notifier.dart';
import 'package:resonate/features/rooms/data/active_room.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

import '../friends/friends_test_helpers.dart';
import '../rooms/rooms_test_helpers.dart';

FriendCallModel _call({FriendCallStatus status = FriendCallStatus.connected}) =>
    FriendCallModel(
      callerName: 'Alice',
      recieverName: 'Bob',
      callerUsername: 'alice',
      recieverUsername: 'bob',
      callerUid: 'caller-uid',
      recieverUid: 'reciever-uid',
      callerProfileImageUrl: 'https://example.com/caller.jpg',
      recieverProfileImageUrl: 'https://example.com/reciever.jpg',
      livekitRoomId: 'room-1',
      callStatus: status,
      docId: 'call-1',
    );

ProviderContainer _container({
  List<Override> overrides = const [],
  FriendCallState call = const FriendCallState(),
}) {
  final container = ProviderContainer(
    overrides: [
      currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'caller-uid')),
      friendCallCoordinatorProvider.overrideWith(
        () => FakeFriendCallCoordinator(initial: call),
      ),
      ...overrides,
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  final room = fakeAppwriteRoom(name: 'Test Room');
  final host = fakeParticipant(uid: 'host', name: 'Host', isAdmin: true);
  final speaker = fakeParticipant(
    uid: 'speaker',
    name: 'Speaker',
    isSpeaker: true,
    dpUrl: 'https://example.com/speaker.jpg',
  );
  final me = fakeParticipant(uid: 'me', name: 'Me', isSpeaker: true);

  List<Override> roomOverrides({
    SingleRoomState? state,
    Map<String, double> levels = const {},
    FakeRoomSession? session,
  }) => [
    roomSessionProvider(room).overrideWith(
      () =>
          session ??
          FakeRoomSession(
            state ?? SingleRoomState(me: me, participants: [host, speaker, me]),
          ),
    ),
    speakingLevelsProvider.overrideWith(() => _StaticLevels(levels)),
  ];

  group('room sessions', () {
    test('carries the room name and the loudest speaker', () async {
      final container = _container(
        overrides: roomOverrides(levels: {'speaker': 0.4, 'host': 0.1}),
      );
      container.read(activeRoomProvider.notifier).enter(room);
      // The session loads asynchronously; there is nothing to show until it has.
      await container.read(roomSessionProvider(room).future);

      final session = container.read(miniplayerProvider);
      expect(session, isNotNull);
      expect(session!.title, 'Test Room');
      expect(session.room, room);
      expect(session.speakerUid, 'speaker');
      expect(session.avatarUrl, 'https://example.com/speaker.jpg');
    });

    test('falls back to the host while the room is silent', () async {
      final container = _container(overrides: roomOverrides());
      container.read(activeRoomProvider.notifier).enter(room);
      await container.read(roomSessionProvider(room).future);

      expect(container.read(miniplayerProvider)?.speakerUid, 'host');
    });

    test('a listener cannot toggle the mic from the miniplayer', () async {
      final listener = fakeParticipant(uid: 'me', name: 'Me');
      final container = _container(
        overrides: roomOverrides(
          state: SingleRoomState(me: listener, participants: [host]),
        ),
      );
      container.read(activeRoomProvider.notifier).enter(room);
      await container.read(roomSessionProvider(room).future);

      expect(container.read(miniplayerProvider)?.canToggleMic, isFalse);
    });

    test('nothing to show once the room is left', () async {
      final container = _container(overrides: roomOverrides());
      container.read(activeRoomProvider.notifier).enter(room);
      await container.read(roomSessionProvider(room).future);
      expect(container.read(miniplayerProvider), isNotNull);

      container.read(activeRoomProvider.notifier).clear();
      expect(container.read(miniplayerProvider), isNull);
    });

    test('toggleMic routes to the room session', () async {
      final session = FakeRoomSession(
        SingleRoomState(me: me, participants: [me]),
      );
      final container = _container(overrides: roomOverrides(session: session));
      container.read(activeRoomProvider.notifier).enter(room);
      await container.read(roomSessionProvider(room).future);

      await container.read(miniplayerProvider.notifier).toggleMic();
      expect(session.turnOnMicCount, 1);

      final micOn = me.copyWith(isMicOn: true);
      session.state = AsyncData(
        SingleRoomState(me: micOn, participants: [micOn]),
      );
      await container.read(miniplayerProvider.notifier).toggleMic();
      expect(session.turnOffMicCount, 1);
    });
  });

  group('call sessions', () {
    test('shows the other side and no title', () {
      final container = _container(
        call: FriendCallState(activeCall: _call(), isMicOn: true),
      );

      final session = container.read(miniplayerProvider);
      expect(session, isNotNull);
      expect(session!.title, isNull);
      expect(session.room, isNull);
      // We are the caller, so the miniplayer shows the receiver.
      expect(session.speakerUid, 'reciever-uid');
      expect(session.isMicOn, isTrue);
      expect(session.canToggleMic, isTrue);
    });

    test('a call that is still ringing has nothing to minimise', () {
      final container = _container(
        call: FriendCallState(
          activeCall: _call(status: FriendCallStatus.waiting),
        ),
      );

      expect(container.read(miniplayerProvider), isNull);
    });

    test('a call outranks a room left open behind it', () {
      final container = _container(
        call: FriendCallState(activeCall: _call()),
        overrides: roomOverrides(),
      );
      container.read(activeRoomProvider.notifier).enter(room);

      expect(container.read(miniplayerProvider)?.title, isNull);
    });

    test('toggleMic routes to the call coordinator', () async {
      final fake = FakeFriendCallCoordinator(
        initial: FriendCallState(activeCall: _call()),
      );
      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWithValue(
            fakeAuthUser(uid: 'caller-uid'),
          ),
          friendCallCoordinatorProvider.overrideWith(() => fake),
        ],
      );
      addTearDown(container.dispose);

      await container.read(miniplayerProvider.notifier).toggleMic();
      expect(fake.toggleMicCount, 1);
    });
  });
}

// Speaking levels are pushed by LiveKit; tests pin them to a fixed sample.
class _StaticLevels extends SpeakingLevels {
  _StaticLevels(this.levels);

  final Map<String, double> levels;

  @override
  Map<String, double> build() => levels;
}
