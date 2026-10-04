import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.mocks.dart';
import '../rooms_test_helpers.dart';

const _roomId = 'room-1';
const _userChannel = 'databases.$databaseId.tables.$usersTableID.rows';

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late StreamController<RealtimeMessage> events;
  late List<Row> participantRows;

  Row participantRow({required String id, required String uid}) => buildRow(
    id: id,
    tableId: participantsTableId,
    databaseId: databaseId,
    data: {
      'roomId': _roomId,
      'uid': uid,
      'isAdmin': false,
      'isModerator': false,
      'isSpeaker': false,
      'isMicOn': false,
      'hasRequestedToBeSpeaker': false,
    },
  );

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    events = stubRealtimeChannel(realtime);
    participantRows = [
      participantRow(id: 'p0', uid: 'me'),
      participantRow(id: 'p1', uid: 'u1'),
    ];

    when(
      tables.listRows(
        databaseId: databaseId,
        tableId: participantsTableId,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer(
      (_) async =>
          RowList(total: participantRows.length, rows: participantRows),
    );
    // Everyone starts with the name their user row carried at room entry.
    stubBatchedUserRows(
      tables,
      rowData: (uid) => {
        'email': '$uid@test.com',
        'name': uid == 'me' ? 'Me' : 'Original',
        'profileImageUrl': 'https://img/$uid-old.png',
      },
    );
  });

  Future<void> flushStreams() async {
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  Future<ProviderContainer> open() async {
    final container = await installTestRootContainer(
      authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
      tables: tables,
      realtime: realtime,
      functions: functions,
    );
    final room = fakeAppwriteRoom(id: _roomId, isUserAdmin: false);
    container.listen(roomSessionProvider(room), (_, _) {});
    await container.read(roomSessionProvider(room).future);
    return container;
  }

  Future<void> emitUser(
    String uid, {
    required String action,
    String? name,
    String? profileImageUrl,
  }) async {
    events.add(
      RealtimeMessage(
        events: ['$_userChannel.$uid.$action'],
        payload: {
          r'$id': uid,
          if (name != null) 'name': name,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        },
        channels: const [_userChannel],
        timestamp: '',
      ),
    );
    await flushStreams();
  }

  Participant participant(ProviderContainer container, String uid) {
    final room = fakeAppwriteRoom(id: _roomId, isUserAdmin: false);
    return container
        .read(roomSessionProvider(room))
        .value!
        .participants
        .firstWhere((p) => p.uid == uid);
  }

  test('a rename reaches the room without a rejoin', () async {
    final container = await open();
    expect(participant(container, 'u1').name, 'Original');

    await emitUser('u1', action: 'update', name: 'Renamed');

    expect(participant(container, 'u1').name, 'Renamed');
  });

  test('a new avatar reaches the room', () async {
    final container = await open();

    await emitUser(
      'u1',
      action: 'update',
      profileImageUrl: 'https://img/u1-new.png',
    );

    expect(participant(container, 'u1').dpUrl, 'https://img/u1-new.png');
  });

  test(
    'a cleared avatar empties the url rather than keeping the old one',
    () async {
      final container = await open();

      await emitUser('u1', action: 'update', profileImageUrl: '');

      expect(participant(container, 'u1').dpUrl, isEmpty);
    },
  );

  test('my own rename updates me, not just the participant list', () async {
    final container = await open();
    final room = fakeAppwriteRoom(id: _roomId, isUserAdmin: false);

    await emitUser('me', action: 'update', name: 'My New Name');

    expect(
      container.read(roomSessionProvider(room)).value!.me.name,
      'My New Name',
    );
    expect(participant(container, 'me').name, 'My New Name');
  });

  test('a stranger editing their profile leaves the room untouched', () async {
    final container = await open();

    await emitUser('nobody-here', action: 'update', name: 'Irrelevant');

    expect(participant(container, 'u1').name, 'Original');
    expect(participant(container, 'me').name, 'Me');
  });

  test('only updates are applied, not creates or deletes', () async {
    final container = await open();

    await emitUser('u1', action: 'create', name: 'From A Create');
    expect(participant(container, 'u1').name, 'Original');

    await emitUser('u1', action: 'delete', name: 'From A Delete');
    expect(participant(container, 'u1').name, 'Original');
  });

  test('a payload carrying neither field changes nothing', () async {
    final container = await open();

    await emitUser('u1', action: 'update');

    expect(participant(container, 'u1').name, 'Original');
    expect(participant(container, 'u1').dpUrl, 'https://img/u1-old.png');
  });
}
