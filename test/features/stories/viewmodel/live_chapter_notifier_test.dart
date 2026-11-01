import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/features/stories/data/services/recorded_chapter_store.dart';
import 'package:resonate/features/stories/data/services/whisper_transcription_service.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../recording_fixtures.dart';
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

  // The end-of-chapter flow, with transcription under the test's control.
  Future<(ProviderContainer, RecordedChapterStore)> endedChapter(
    Future<String> transcription,
  ) async {
    final recordings =
        Directory.systemTemp.createTempSync('resonate_recordings');
    addTearDown(() {
      if (recordings.existsSync()) recordings.deleteSync(recursive: true);
    });
    File('${recordings.path}/room-1.wav')
        .writeAsBytesSync(wavBytes(seconds: 3));
    final store = RecordedChapterStore(directory: () async => recordings);

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

    final container = await installTestRootContainer(
      authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
      tables: tables,
      realtime: realtime,
      functions: functions,
      overrides: [
        recordedChapterStoreProvider.overrideWithValue(store),
        whisperTranscriptionServiceProvider.overrideWith(
          (ref, model) => _FakeTranscription(transcription),
        ),
      ],
    );

    await container.read(liveChapterProvider.notifier).startLiveChapter(
          roomId: 'room-1',
          chapterTitle: 'My Live Chapter',
          chapterDescription: 'desc',
          storyId: 'story-1',
          storyName: 'My Story',
        );
    await container.read(liveChapterProvider.notifier).endLiveChapter();
    return (container, store);
  }

  // Transcription takes about as long as the recording, so the author must be
  // out of the room before it starts rather than after it finishes.
  test('endLiveChapter returns while the transcript is still being made',
      () async {
    final stuck = Completer<String>();
    addTearDown(() => stuck.complete(''));
    final (container, _) = await endedChapter(stuck.future);

    expect(container.read(liveChapterProvider).transcript.isLoading, isTrue);
    expect(container.read(liveKitControllerProvider).isConnected, isFalse);
    expect(container.read(liveKitControllerProvider).isRecording, isFalse);
  });

  test('the transcript lands in state and in the archive once it is ready',
      () async {
    final (container, store) =
        await endedChapter(Future.value('[00:01.000]hello'));
    await _settledTranscript(container);

    expect(
      container.read(liveChapterProvider).transcript.value,
      '[00:01.000]hello',
    );
    final archived = (await store.readIndex()).single;
    expect(archived.id, 'room-1');
    expect(archived.title, 'My Live Chapter');
    expect(archived.description, 'desc');
    expect(archived.transcript, '[00:01.000]hello');
    expect(archived.durationMs, 3000);
    expect(archived.recordedAt.isUtc, isTrue);
  });
}

Future<void> _settledTranscript(ProviderContainer container) async {
  for (var i = 0; i < 200; i++) {
    if (!container.read(liveChapterProvider).transcript.isLoading) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('transcription never settled');
}

class _FakeTranscription extends WhisperTranscriptionService {
  _FakeTranscription(this.lyrics);

  final Future<String> lyrics;

  @override
  Future<String> transcribeChapter(String chapterId) => lyrics;
}
