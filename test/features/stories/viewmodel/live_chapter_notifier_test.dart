import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/stories/viewmodel/live_chapter_notifier.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

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
  late StreamController<RealtimeMessage> attendeeEvents;

  setUp(() {
    stubFlutterSecureStorageChannel();
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    attendeeEvents = StreamController<RealtimeMessage>.broadcast();
    when(realtime.subscribe(any)).thenReturn(
      RealtimeSubscription(
        close: () async {},
        channels: const ['attendees'],
        controller: attendeeEvents,
      ),
    );
  });

  tearDown(() => attendeeEvents.close());

  Future<dynamic> install() => installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

  test('turnOnMic / turnOffMic flip the mic flag', () async {
    final container = await install();

    await container.read(liveChapterProvider.notifier).turnOnMic();
    expect(container.read(liveChapterProvider).isMicOn, isTrue);

    await container.read(liveChapterProvider.notifier).turnOffMic();
    expect(container.read(liveChapterProvider).isMicOn, isFalse);
  });

  test('checkUserIsAdmin is false with no live chapter loaded', () async {
    final container = await install();
    expect(
      container.read(liveChapterProvider.notifier).checkUserIsAdmin('me'),
      isFalse,
    );
    expect(container.read(liveChapterProvider.notifier).isAdmin, isFalse);
  });

  test('startLiveChapter creates docs, connects and stores the model',
      () async {
    when(tables.createRow(
      databaseId: anyNamed('databaseId'),
      tableId: anyNamed('tableId'),
      rowId: anyNamed('rowId'),
      data: anyNamed('data'),
    )).thenAnswer((_) async => buildRow(id: 'x', data: const {}));
    when(functions.createExecution(
      functionId: createLiveChapterRoomFunctionId,
      body: anyNamed('body'),
    )).thenAnswer((_) async => _execution(
          '{"livekit_socket_url":"wss://example.com","access_token":"tok"}',
        ));

    final container = await install();

    await container.read(liveChapterProvider.notifier).startLiveChapter(
          roomId: 'room-1',
          chapterTitle: 'My Live Chapter',
          chapterDescription: 'desc',
          storyId: 'story-1',
          storyName: 'My Story',
        );

    final state = container.read(liveChapterProvider);
    expect(state.model, isNotNull);
    expect(state.model!.chapterTitle, 'My Live Chapter');
    // The author is admin of their own live chapter.
    expect(container.read(liveChapterProvider.notifier).isAdmin, isTrue);
  });

  test('joinLiveChapter adds the current user to the attendees', () async {
    when(tables.updateRow(
      databaseId: anyNamed('databaseId'),
      tableId: anyNamed('tableId'),
      rowId: anyNamed('rowId'),
      data: anyNamed('data'),
    )).thenAnswer((_) async => buildRow(id: 'room-1', data: const {}));
    when(functions.createExecution(
      functionId: joinRoomServiceId,
      body: anyNamed('body'),
    )).thenAnswer((_) async => _execution(
          '{"livekit_socket_url":"wss://example.com","access_token":"jtok"}',
        ));

    final container = await install();

    await container.read(liveChapterProvider.notifier).joinLiveChapter(
          'room-1',
          fakeLiveChapterModel(
            authorUid: 'author-9',
            chapterTitle: 'Joined Chapter',
            attendees: fakeLiveChapterAttendees(),
          ),
        );

    final state = container.read(liveChapterProvider);
    expect(state.model, isNotNull);
    expect(state.model!.attendees!.users, hasLength(1));
    expect(state.model!.attendees!.users.first.id, 'me');
  });
}
