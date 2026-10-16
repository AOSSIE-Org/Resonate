import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/report_type_enum.dart';

import '../../../helpers/test_root_container.mocks.dart';
import '../rooms_test_helpers.dart';

const _roomId = 'room-1';
const _myDocId = 'my-doc';

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
    bool isSpeaker = false,
  }) => buildRow(
    id: id,
    tableId: participantsTableId,
    databaseId: databaseId,
    data: {
      'roomId': _roomId,
      'uid': uid,
      'isAdmin': isAdmin,
      'isModerator': isModerator,
      'isSpeaker': isSpeaker,
      'isMicOn': false,
      'hasRequestedToBeSpeaker': false,
    },
  );

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    subscription = MockRealtimeSubscription();
    participantEvents = StreamController<RealtimeMessage>.broadcast();
    participantRows = [participantRow(id: 'p1', uid: 'guest')];

    when(subscription.stream).thenAnswer((_) => participantEvents.stream);
    when(subscription.close).thenReturn(() async {});
    when(realtime.subscribe(any)).thenReturn(subscription);

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
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => buildRow(id: 'x', data: const {}));
    when(
      tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => buildRow(id: 'x', data: const {}));
    when(
      tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      ),
    ).thenAnswer((_) async {});
    stubBatchedUserRows(tables);
  });

  tearDown(() => participantEvents.close());

  final room = fakeAppwriteRoom(id: _roomId, myDocId: _myDocId);

  Future<ProviderContainer> open({AppwriteRoom? withRoom}) async {
    final container = await installTestRootContainer(
      authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
      tables: tables,
      realtime: realtime,
      functions: functions,
    );
    final target = withRoom ?? room;
    container.listen(roomSessionProvider(target), (_, _) {});
    await container.read(roomSessionProvider(target).future);
    return container;
  }

  Participant meIn(ProviderContainer c, [AppwriteRoom? r]) =>
      c.read(roomSessionProvider(r ?? room)).value!.me;

  // The data map handed to a participant-row update, by rowId.
  Map<String, dynamic> participantUpdate(String rowId) {
    final captured = verify(
      tables.updateRow(
        databaseId: databaseId,
        tableId: participantsTableId,
        rowId: rowId,
        data: captureAnyNamed('data'),
      ),
    ).captured;
    return captured.last as Map<String, dynamic>;
  }

  group('mic', () {
    test('turnOnMic flips my state and writes the flag', () async {
      final container = await open();
      expect(meIn(container).isMicOn, isFalse);

      await container.read(roomSessionProvider(room).notifier).turnOnMic(room);

      expect(meIn(container).isMicOn, isTrue);
      expect(participantUpdate(_myDocId), {'isMicOn': true});
    });

    test('turnOffMic flips it back', () async {
      final container = await open();
      final notifier = container.read(roomSessionProvider(room).notifier);
      await notifier.turnOnMic(room);

      await notifier.turnOffMic(room);

      expect(meIn(container).isMicOn, isFalse);
      expect(participantUpdate(_myDocId), {'isMicOn': false});
    });

    // A listener who has never been given a row has nothing to write to.
    test('no participant row means no write', () async {
      final roomWithoutDoc = fakeAppwriteRoom(id: _roomId);
      final container = await open(withRoom: roomWithoutDoc);

      await container
          .read(roomSessionProvider(roomWithoutDoc).notifier)
          .turnOnMic(roomWithoutDoc);

      expect(meIn(container, roomWithoutDoc).isMicOn, isTrue);
      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: participantsTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });

    // The mic is already live locally; a failed write must not throw back into
    // the button handler.
    test('a failed write is swallowed and the local state stands', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('offline'));
      final container = await open();

      await expectLater(
        container.read(roomSessionProvider(room).notifier).turnOnMic(room),
        completes,
      );
      expect(meIn(container).isMicOn, isTrue);
    });
  });

  group('raising a hand', () {
    test('raiseHand writes the request and reflects it locally', () async {
      final container = await open();

      await container.read(roomSessionProvider(room).notifier).raiseHand(room);

      expect(meIn(container).hasRequestedToBeSpeaker, isTrue);
      expect(participantUpdate(_myDocId), {'hasRequestedToBeSpeaker': true});
    });

    test('unRaiseHand withdraws it', () async {
      final container = await open();
      final notifier = container.read(roomSessionProvider(room).notifier);
      await notifier.raiseHand(room);

      await notifier.unRaiseHand(room);

      expect(meIn(container).hasRequestedToBeSpeaker, isFalse);
      expect(participantUpdate(_myDocId), {'hasRequestedToBeSpeaker': false});
    });
  });

  group('setRole', () {
    final guest = Participant(
      uid: 'guest',
      email: 'guest@test.com',
      name: 'Guest',
      dpUrl: '',
      isAdmin: false,
      isMicOn: false,
      isModerator: false,
      isSpeaker: false,
      hasRequestedToBeSpeaker: true,
    );

    Participant guestIn(ProviderContainer c) => c
        .read(roomSessionProvider(room))
        .value!
        .participants
        .firstWhere((p) => p.uid == 'guest');

    test(
      'promoting to moderator sets both flags and clears the request',
      () async {
        final container = await open();

        await container
            .read(roomSessionProvider(room).notifier)
            .setRole(room, guest, ParticipantRole.moderator);

        expect(participantUpdate('p1'), {
          'isModerator': true,
          'isSpeaker': true,
          'hasRequestedToBeSpeaker': false,
        });
        final updated = guestIn(container);
        expect(updated.isModerator, isTrue);
        expect(updated.isSpeaker, isTrue);
        expect(updated.hasRequestedToBeSpeaker, isFalse);
      },
    );

    test('promoting to speaker does not make them a moderator', () async {
      final container = await open();

      await container
          .read(roomSessionProvider(room).notifier)
          .setRole(room, guest, ParticipantRole.speaker);

      expect(participantUpdate('p1'), {
        'isModerator': false,
        'isSpeaker': true,
        'hasRequestedToBeSpeaker': false,
      });
      expect(guestIn(container).isSpeaker, isTrue);
      expect(guestIn(container).isModerator, isFalse);
    });

    test('demoting to listener clears both flags', () async {
      final container = await open();

      await container
          .read(roomSessionProvider(room).notifier)
          .setRole(room, guest, ParticipantRole.listener);

      expect(participantUpdate('p1'), {
        'isModerator': false,
        'isSpeaker': false,
        'hasRequestedToBeSpeaker': false,
      });
      expect(guestIn(container).isSpeaker, isFalse);
    });

    // Looking the row up each time is what makes this safe: the row is gone
    // once they leave, and promoting a ghost would write to nothing.
    test('a participant who already left is not written to', () async {
      participantRows = [];
      final container = await open();

      await container
          .read(roomSessionProvider(room).notifier)
          .setRole(room, guest, ParticipantRole.moderator);

      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: participantsTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });
  });

  group('kickOutParticipant', () {
    final guest = Participant(
      uid: 'guest',
      email: 'guest@test.com',
      name: 'Guest',
      dpUrl: '',
      isAdmin: false,
      isMicOn: false,
      isModerator: false,
      isSpeaker: false,
      hasRequestedToBeSpeaker: false,
    );

    test('deletes the participant row', () async {
      final container = await open();

      await container
          .read(roomSessionProvider(room).notifier)
          .kickOutParticipant(room, guest);

      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p1',
        ),
      ).called(1);
    });

    test('a participant who already left is a no-op', () async {
      participantRows = [];
      final container = await open();

      await container
          .read(roomSessionProvider(room).notifier)
          .kickOutParticipant(room, guest);

      verifyNever(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      );
    });
  });

  group('reportAndKick', () {
    final guest = Participant(
      uid: 'guest',
      email: 'guest@test.com',
      name: 'Guest',
      dpUrl: '',
      isAdmin: false,
      isMicOn: false,
      isModerator: false,
      isSpeaker: false,
      hasRequestedToBeSpeaker: false,
    );

    const draft = (type: ReportTypeEnum.harassment, details: 'was abusive');

    test('files the report, marks the room, and kicks', () async {
      final container = await open();

      final ok = await container
          .read(roomSessionProvider(room).notifier)
          .reportAndKick(room, guest, report: draft);

      expect(ok, isTrue);

      final report =
          verify(
                tables.createRow(
                  databaseId: databaseId,
                  tableId: userReportsTableID,
                  rowId: anyNamed('rowId'),
                  data: captureAnyNamed('data'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(report['reporterUid'], 'me');
      expect(report['reportedUid'], 'guest');
      expect(report['reportText'], 'was abusive');

      // The SDK hands the captured map back untyped.
      final roomUpdate =
          verify(
                tables.updateRow(
                  databaseId: databaseId,
                  tableId: roomsTableId,
                  rowId: _roomId,
                  data: captureAnyNamed('data'),
                ),
              ).captured.single
              as Map;
      expect(roomUpdate['reportedUsers'], ['guest']);

      verify(
        tables.deleteRow(
          databaseId: databaseId,
          tableId: participantsTableId,
          rowId: 'p1',
        ),
      ).called(1);
    });

    test('keeps the users already on the reported list', () async {
      final reportedRoom = fakeAppwriteRoom(
        id: _roomId,
        myDocId: _myDocId,
        reportedUsers: const ['earlier'],
      );
      final container = await open(withRoom: reportedRoom);

      await container
          .read(roomSessionProvider(reportedRoom).notifier)
          .reportAndKick(reportedRoom, guest, report: draft);

      // The SDK hands the captured map back untyped.
      final roomUpdate =
          verify(
                tables.updateRow(
                  databaseId: databaseId,
                  tableId: roomsTableId,
                  rowId: _roomId,
                  data: captureAnyNamed('data'),
                ),
              ).captured.single
              as Map;
      expect(roomUpdate['reportedUsers'], ['earlier', 'guest']);
    });

    // Kicking without a filed report would lose the moderation trail, so a
    // failed report has to abort the whole action.
    test('a failed report aborts the kick and reports failure', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: userReportsTableID,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(AppwriteException('rejected'));
      final container = await open();

      final ok = await container
          .read(roomSessionProvider(room).notifier)
          .reportAndKick(room, guest, report: draft);

      expect(ok, isFalse);
      verifyNever(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      );
    });
  });
}
