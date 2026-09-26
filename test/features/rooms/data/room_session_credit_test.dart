import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/rooms/data/active_room.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';
import '../rooms_test_helpers.dart';

const _roomId = 'room-1';
const _participantChannel =
    'databases.$masterDatabaseId.tables.$participantsTableId.rows';

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late MockRealtimeSubscription subscription;
  late StreamController<RealtimeMessage> participantEvents;
  late List<Row> participantRows;

  Row participantRow({
    required String id,
    required String uid,
    bool isAdmin = false,
    bool isModerator = false,
  }) => buildRow(
    id: id,
    tableId: participantsTableId,
    databaseId: masterDatabaseId,
    data: {
      'roomId': _roomId,
      'uid': uid,
      'isAdmin': isAdmin,
      'isModerator': isModerator,
      'isSpeaker': isModerator,
      'isMicOn': false,
      'hasRequestedToBeSpeaker': false,
    },
  );

  // Row.fromMap needs the $ keys and participantStream filters a top-level roomId.
  Map<String, dynamic> flatPayload(Row row) => {
    ...row.toMap()..remove('data'),
    ...row.data,
  };

  List<Row> crowd(int count) => [
    for (var i = 0; i < count; i++) participantRow(id: 'p$i', uid: 'u$i'),
  ];

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    subscription = MockRealtimeSubscription();
    participantEvents = StreamController<RealtimeMessage>.broadcast();
    participantRows = [];

    when(subscription.stream).thenAnswer((_) => participantEvents.stream);
    when(subscription.close).thenReturn(() async {});
    when(realtime.subscribe(any)).thenReturn(subscription);

    when(
      tables.listRows(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer(
      (_) async =>
          RowList(total: participantRows.length, rows: participantRows),
    );
    when(
      tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: anyNamed('rowId'),
      ),
    ).thenAnswer(
      (invocation) async => buildRow(
        id: invocation.namedArguments[#rowId] as String,
        tableId: usersTableID,
        databaseId: userDatabaseID,
        data: const {
          'email': 'someone@test.com',
          'name': 'Someone',
          'profileImageUrl': '',
        },
      ),
    );
  });

  tearDown(() => participantEvents.close());

  // The create branch fetches a user row first, so one turn is not enough.
  Future<void> flushStreams() async {
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  Future<ProviderContainer> open({
    required FakeActivityRecorder recorder,
    bool isUserAdmin = true,
  }) async {
    final container = await installTestRootContainer(
      authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
      tables: tables,
      realtime: realtime,
      functions: functions,
      activityRecorder: recorder,
    );
    final room = fakeAppwriteRoom(id: _roomId, isUserAdmin: isUserAdmin);
    container.listen(roomSessionProvider(room), (_, _) {});
    await container.read(roomSessionProvider(room).future);
    return container;
  }

  test('a host in a room of six asks for credit', () async {
    participantRows = crowd(6);
    final recorder = FakeActivityRecorder();

    await open(recorder: recorder);

    expect(recorder.roomCredits, [_roomId]);
  });

  test('a host in a room of five does not', () async {
    participantRows = crowd(5);
    final recorder = FakeActivityRecorder();

    await open(recorder: recorder);

    expect(recorder.roomCredits, isEmpty);
  });

  test('a plain listener never asks, however big the room', () async {
    participantRows = crowd(10);
    final recorder = FakeActivityRecorder();

    await open(recorder: recorder, isUserAdmin: false);

    expect(recorder.roomCredits, isEmpty);
  });

  test('the sixth person arriving triggers the ask', () async {
    participantRows = crowd(5);
    final recorder = FakeActivityRecorder();
    await open(recorder: recorder);
    expect(recorder.roomCredits, isEmpty, reason: 'five is not enough');

    participantEvents.add(
      RealtimeMessage(
        events: ['$_participantChannel.p5.create'],
        payload: flatPayload(participantRow(id: 'p5', uid: 'u5')),
        channels: const [_participantChannel],
        timestamp: '',
      ),
    );
    await flushStreams();

    expect(recorder.roomCredits, [_roomId]);
  });

  group('my own row being deleted', () {
    // AppwriteRoom is freezed, so an identical room is the same family key.
    final room = fakeAppwriteRoom(id: _roomId, isUserAdmin: false);

    Future<void> deleteRow(Row row) async {
      participantEvents.add(
        RealtimeMessage(
          events: ['$_participantChannel.${row.$id}.delete'],
          payload: flatPayload(row),
          channels: const [_participantChannel],
          timestamp: '',
        ),
      );
      await flushStreams();
    }

    Future<void> deleteMe(ProviderContainer container) =>
        deleteRow(participantRow(id: 'p0', uid: 'me'));

    Future<ProviderContainer> openInRoom() async {
      participantRows = [participantRow(id: 'p0', uid: 'me'), ...crowd(2)];
      final container = await open(
        recorder: FakeActivityRecorder(),
        isUserAdmin: false,
      );
      await container
          .read(liveKitControllerProvider.notifier)
          .connect(liveKitUri: 'uri', roomToken: 'token');
      return container;
    }

    test('is a kick while the room is still mine', () async {
      final container = await openInRoom();
      container.read(activeRoomProvider.notifier).enter(room);

      await deleteMe(container);

      expect(container.read(roomSessionProvider(room)).value?.wasKicked, true);
      expect(container.read(liveKitControllerProvider).isConnected, false);
    });

    test('is not a kick once I have given the room up', () async {
      final container = await openInRoom();
      // What RoomLauncher.leave does before it deletes the row.
      container.read(activeRoomProvider.notifier).clear();

      await deleteMe(container);

      expect(container.read(roomSessionProvider(room)).value?.wasKicked, false);
      // leave() owns the disconnect; doing it again could cut the next room.
      expect(container.read(liveKitControllerProvider).isConnected, true);
    });

    test('reads as an ending, not a kick, once the host row has gone', () async {
      final container = await openInRoom();
      container.read(activeRoomProvider.notifier).enter(room);

      // What deleteRoom broadcasts first when the host closes the room.
      await deleteRow(participantRow(id: 'host', uid: 'u0', isAdmin: true));
      await deleteMe(container);

      final session = container.read(roomSessionProvider(room)).value;
      expect(session?.roomEnded, true);
      expect(session?.wasKicked, false);
      // Still a departure: the audio session goes either way.
      expect(container.read(liveKitControllerProvider).isConnected, false);
    });

    test('is not a kick when I have already moved to another room', () async {
      final container = await openInRoom();
      container
          .read(activeRoomProvider.notifier)
          .enter(fakeAppwriteRoom(id: 'room-2'));

      await deleteMe(container);

      expect(container.read(roomSessionProvider(room)).value?.wasKicked, false);
      expect(container.read(liveKitControllerProvider).isConnected, true);
    });
  });

  test('being made a moderator in a big room triggers the ask', () async {
    participantRows = [participantRow(id: 'p0', uid: 'me'), ...crowd(5)];
    final recorder = FakeActivityRecorder();
    await open(recorder: recorder, isUserAdmin: false);
    expect(recorder.roomCredits, isEmpty, reason: 'only a listener so far');

    participantEvents.add(
      RealtimeMessage(
        events: ['$_participantChannel.p0.update'],
        payload: flatPayload(
          participantRow(id: 'p0', uid: 'me', isModerator: true),
        ),
        channels: const [_participantChannel],
        timestamp: '',
      ),
    );
    await flushStreams();

    expect(recorder.roomCredits, [_roomId]);
  });
}
