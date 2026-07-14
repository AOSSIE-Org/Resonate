import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/stories/data/repositories/live_chapter_repository.dart';
import 'package:resonate/core/services/api_service.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

const _secureStorageChannel =
    MethodChannel('plugins.it_nomads.com/flutter_secure_storage');


void stubSecureStorage({String? readValue}) {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    _secureStorageChannel,
    (call) async => call.method == 'read' ? readValue : null,
  );
}

MockExecution _execution(String body) {
  final exec = MockExecution();
  when(exec.responseStatusCode).thenReturn(200);
  when(exec.responseBody).thenReturn(body);
  return exec;
}

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late MockRealtimeSubscription subscription;
  late StreamController<RealtimeMessage> events;
  late LiveChapterRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    subscription = MockRealtimeSubscription();
    events = StreamController<RealtimeMessage>.broadcast();
    stubSecureStorage();
    repo = LiveChapterRepository(
      tables: tables,
      realtime: realtime,
      functions: functions,
      apiService: ApiService(functions: functions),
    );
  });

  tearDown(() => events.close());

  group('createLiveChapterRoom', () {
    test('returns the LiveKit join params from the cloud function', () async {
      when(functions.createExecution(
        functionId: createLiveChapterRoomFunctionId,
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution(
            '{"livekit_socket_url":"wss://example.com","access_token":"tok"}',
          ));

      final join = await repo.createLiveChapterRoom(
        appwriteRoomId: 'room-1',
        adminUid: 'me',
      );

      expect(join.liveKitUri, 'wss://example.com');
      expect(join.roomToken, 'tok');
    });
  });

  group('joinLiveChapterRoom', () {
    test('returns the LiveKit join params from the join function', () async {
      when(functions.createExecution(
        functionId: joinRoomServiceId,
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution(
            '{"livekit_socket_url":"wss://example.com","access_token":"jtok"}',
          ));

      final join = await repo.joinLiveChapterRoom(roomId: 'room-1', userId: 'me');

      expect(join.roomToken, 'jtok');
    });
  });

  group('deleteLiveChapterRoom', () {
    test('calls the delete function when an admin token is stored', () async {
      stubSecureStorage(readValue: 'admin-token');
      when(functions.createExecution(
        functionId: deleteLiveChapterRoomFunctionId,
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution('{"status":"deleted"}'));

      await repo.deleteLiveChapterRoom('room-1');

      verify(functions.createExecution(
        functionId: deleteLiveChapterRoomFunctionId,
        body: anyNamed('body'),
      )).called(1);
    });

    test('is a no-op when no admin token is stored', () async {
      stubSecureStorage(); // read → null

      await repo.deleteLiveChapterRoom('room-1');

      verifyNever(functions.createExecution(
        functionId: deleteLiveChapterRoomFunctionId,
        body: anyNamed('body'),
      ));
    });
  });

  group('createLiveChapterDocs', () {
    test('writes the live-chapter row and the attendees row', () async {
      when(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => buildRow(id: 'x', data: const {}));

      await repo.createLiveChapterDocs(
        fakeLiveChapterModel(authorUid: 'me', attendees: fakeLiveChapterAttendees()),
      );

      verify(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: liveChaptersTableId,
        rowId: 'room-1',
        data: anyNamed('data'),
      )).called(1);
      verify(tables.createRow(
        databaseId: userDatabaseID,
        tableId: liveChapterAttendeesTableId,
        rowId: 'room-1',
        data: anyNamed('data'),
      )).called(1);
    });
  });

  group('updateAttendees', () {
    test('updates the attendees row', () async {
      when(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => buildRow(id: 'room-1', data: const {}));

      await repo.updateAttendees(
        'room-1',
        fakeLiveChapterAttendees(userIds: const ['me']),
      );

      verify(tables.updateRow(
        databaseId: userDatabaseID,
        tableId: liveChapterAttendeesTableId,
        rowId: 'room-1',
        data: anyNamed('data'),
      )).called(1);
    });
  });

  group('deleteLiveChapterDocs', () {
    test('deletes both the live-chapter and attendees rows', () async {
      when(tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      )).thenAnswer((_) async => '');

      await repo.deleteLiveChapterDocs('room-1');

      verify(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: liveChaptersTableId,
        rowId: 'room-1',
      )).called(1);
      verify(tables.deleteRow(
        databaseId: userDatabaseID,
        tableId: liveChapterAttendeesTableId,
        rowId: 'room-1',
      )).called(1);
    });
  });

  group('attendeesStream', () {
    test('forwards events that carry a payload and skips empty ones', () async {
      when(realtime.subscribe(any)).thenReturn(subscription);
      when(subscription.stream).thenAnswer((_) => events.stream);
      when(subscription.close).thenReturn(() async {});

      final received = <RealtimeMessage>[];
      final sub = repo.attendeesStream('room-1').listen(received.add);

      final channel = LiveChapterRepository.attendeesChannel('room-1');
      events.add(RealtimeMessage(
        events: ['$channel.update'],
        payload: {'liveChapterId': 'room-1'},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      events.add(RealtimeMessage(
        events: ['$channel.update'],
        payload: const {},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      await pumpEventQueue();

      expect(received, hasLength(1));
      await sub.cancel();
    });

    test('builds the attendees channel string', () {
      expect(
        LiveChapterRepository.attendeesChannel('room-1'),
        'databases.$userDatabaseID.tables.$liveChapterAttendeesTableId.rows.room-1',
      );
    });
  });

  group('sendLiveChapterNotification', () {
    test('invokes the story notification function', () async {
      when(functions.createExecution(
        functionId: sendStoryNotificationFunctionID,
        body: anyNamed('body'),
      )).thenAnswer((_) async => _execution('{}'));

      await repo.sendLiveChapterNotification(
        creatorId: 'me',
        title: 'Live Chapter Starting!',
        body: 'Tune in',
      );

      verify(functions.createExecution(
        functionId: sendStoryNotificationFunctionID,
        body: anyNamed('body'),
      )).called(1);
    });
  });
}
