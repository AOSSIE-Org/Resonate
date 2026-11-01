import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
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
