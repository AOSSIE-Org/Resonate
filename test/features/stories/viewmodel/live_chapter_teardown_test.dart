import 'dart:async';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/data/services/live_chapter_coordinator.dart';
import 'package:resonate/features/stories/data/services/recorded_chapter_store.dart';
import 'package:resonate/features/stories/data/services/whisper_transcription_service.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';
import '../recording_fixtures.dart';

MockExecution _execution(String body) {
  final exec = MockExecution();
  when(exec.responseStatusCode).thenReturn(200);
  when(exec.responseBody).thenReturn(body);
  return exec;
}


GoRouter _testRouter() => GoRouter(
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      builder: (_, _) => const SizedBox.shrink(),
    ),
    GoRoute(
      path: RoutePaths.tabview,
      builder: (_, _) => const SizedBox.shrink(),
    ),
  ],
);

String _locationOf(GoRouter router) =>
    router.routeInformationProvider.value.uri.toString();

class _FakeTranscription extends WhisperTranscriptionService {
  _FakeTranscription(this.lyrics);

  final Future<String> Function() lyrics;

  @override
  Future<String> transcribeChapter(String chapterId) => lyrics();
}

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late StreamController<RealtimeMessage> attendeeEvents;
  late GoRouter router;

  setUp(() {
    stubFlutterSecureStorageChannel();
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    attendeeEvents = StreamController<RealtimeMessage>.broadcast();
    router = _testRouter();
    when(realtime.subscribe(any)).thenReturn(
      RealtimeSubscription(
        close: () async {},
        channels: const ['attendees'],
        controller: attendeeEvents,
      ),
    );
    when(
      tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => buildRow(id: 'x', data: const {}));
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => buildRow(id: 'room-1', data: const {}));
    when(
      tables.deleteRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    attendeeEvents.close();
    router.dispose();
  });

  Future<ProviderContainer> install({List<Override> overrides = const []}) =>
      installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
        overrides: [routerProvider.overrideWithValue(router), ...overrides],
      );

  // Joins as a listener, so `isAdmin` is false and the attendee stream is live.
  Future<ProviderContainer> joinedAsListener({
    List<Override> overrides = const [],
  }) async {
    when(
      functions.createExecution(
        functionId: joinRoomServiceId,
        body: anyNamed('body'),
      ),
    ).thenAnswer(
      (_) async => _execution(
        '{"livekit_socket_url":"wss://example.com","access_token":"jtok"}',
      ),
    );
    final container = await install(overrides: overrides);
    await container
        .read(liveChapterProvider.notifier)
        .joinLiveChapter(
          'room-1',
          fakeLiveChapterModel(
            authorUid: 'author-9',
            attendees: fakeLiveChapterAttendees(),
          ),
        );
    return container;
  }

  Future<void> emitAttendees(
    String action,
    Map<String, dynamic> payload,
  ) async {
    attendeeEvents.add(
      RealtimeMessage(
        events: [
          'databases.$databaseId.tables.$liveChapterAttendeesTableId'
              '.rows.room-1.$action',
        ],
        payload: payload,
        channels: const ['attendees'],
        timestamp: '',
      ),
    );
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  group('the attendee stream', () {
    test('an update swaps in the new attendee list', () async {
      final container = await joinedAsListener();

      await emitAttendees('update', {
        'liveChapterId': 'room-1',
        'users': [
          {'\$id': 'me', 'name': 'Me'},
          {'\$id': 'friend', 'name': 'Friend'},
        ],
      });

      final attendees = container.read(liveChapterProvider).model!.attendees!;
      expect(attendees.users.map((u) => u.id), ['me', 'friend']);
    });

    // The host ending the chapter deletes the attendees row; that is how a
    // listener learns the chapter is over.
    test('a delete drops a listener out of the chapter', () async {
      final container = await joinedAsListener();
      expect(container.read(liveKitControllerProvider).isConnected, isTrue);

      await emitAttendees('delete', {'liveChapterId': 'room-1'});

      expect(container.read(liveChapterProvider).model, isNull);
      expect(container.read(liveKitControllerProvider).isConnected, isFalse);
      expect(_locationOf(router), RoutePaths.tabview);
    });

    // The host is already running their own teardown; reacting to their own
    // delete would tear it down twice.
    test('a delete leaves the host alone', () async {
      when(
        functions.createExecution(
          functionId: createLiveChapterRoomFunctionId,
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => _execution(
          '{"livekit_socket_url":"wss://example.com","access_token":"tok"}',
        ),
      );
      final container = await install();
      await container
          .read(liveChapterProvider.notifier)
          .startLiveChapter(
            roomId: 'room-1',
            chapterTitle: 'Mine',
            chapterDescription: 'desc',
            storyId: 'story-1',
            storyName: 'My Story',
          );

      await emitAttendees('delete', {'liveChapterId': 'room-1'});

      expect(container.read(liveChapterProvider).model, isNotNull);
      expect(_locationOf(router), RoutePaths.splash);
    });

    test('a malformed payload does not kill the subscription', () async {
      final container = await joinedAsListener();

      await emitAttendees('update', {'nonsense': true});
      expect(container.read(liveChapterProvider).model, isNotNull);

      await emitAttendees('update', {
        'liveChapterId': 'room-1',
        'users': [
          {'\$id': 'friend'},
        ],
      });
      expect(
        container.read(liveChapterProvider).model!.attendees!.users.single.id,
        'friend',
      );
    });
  });

  group('leaveRoom', () {
    test('writes the remaining attendees and sends me back', () async {
      final container = await joinedAsListener();
      await emitAttendees('update', {
        'liveChapterId': 'room-1',
        'users': [
          {'\$id': 'me'},
          {'\$id': 'friend'},
        ],
      });

      await container.read(liveChapterProvider.notifier).leaveRoom();

      final written =
          verify(
                tables.updateRow(
                  databaseId: databaseId,
                  tableId: liveChapterAttendeesTableId,
                  rowId: 'room-1',
                  data: captureAnyNamed('data'),
                ),
              ).captured.last
              as Map;
      expect(written['users'], ['friend']);
      expect(container.read(liveChapterProvider).model, isNull);
      expect(container.read(liveKitControllerProvider).isConnected, isFalse);
      expect(_locationOf(router), RoutePaths.tabview);
    });

    test('is a no-op with no chapter loaded', () async {
      final container = await install();

      await container.read(liveChapterProvider.notifier).leaveRoom();

      expect(_locationOf(router), RoutePaths.splash);
      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: liveChapterAttendeesTableId,
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });
  });

  group('endLiveChapter', () {
    Future<ProviderContainer> hostedChapter({
      required Future<String> Function() transcription,
      RecordedChapterStore? store,
    }) async {
      when(
        functions.createExecution(
          functionId: createLiveChapterRoomFunctionId,
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => _execution(
          '{"livekit_socket_url":"wss://example.com","access_token":"tok"}',
        ),
      );
      final container = await install(
        overrides: [
          if (store != null)
            recordedChapterStoreProvider.overrideWithValue(store),
          whisperTranscriptionServiceProvider.overrideWith(
            (ref, model) => _FakeTranscription(transcription),
          ),
        ],
      );
      await container
          .read(liveChapterProvider.notifier)
          .startLiveChapter(
            roomId: 'room-1',
            chapterTitle: 'My Live Chapter',
            chapterDescription: 'desc',
            storyId: 'story-1',
            storyName: 'My Story',
          );
      return container;
    }

    RecordedChapterStore tempStore() {
      final dir = Directory.systemTemp.createTempSync('resonate_teardown');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      File('${dir.path}/room-1.wav').writeAsBytesSync(wavBytes(seconds: 2));
      return RecordedChapterStore(directory: () async => dir);
    }

    test('is a no-op with no chapter loaded', () async {
      final container = await install();

      await container.read(liveChapterProvider.notifier).endLiveChapter();

      verifyNever(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      );
    });

    // Each teardown step is best-effort: a chapter that cannot be deleted
    // server-side must still release the author and get transcribed.
    test('a failed document delete does not stop the teardown', () async {
      final store = tempStore();
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenThrow(AppwriteException('row locked'));
      final container = await hostedChapter(
        transcription: () async => 'hello',
        store: store,
      );

      await container.read(liveChapterProvider.notifier).endLiveChapter();
      await _settledTranscript(container);

      expect(container.read(liveKitControllerProvider).isConnected, isFalse);
      expect(container.read(liveChapterProvider).transcript.value, 'hello');
    });

    // The recording is on the device either way; losing the transcript must
    // not also lose the audio.
    test('a failed transcription still archives the recording', () async {
      final store = tempStore();
      final container = await hostedChapter(
        transcription: () async => throw StateError('whisper fell over'),
        store: store,
      );

      await container.read(liveChapterProvider.notifier).endLiveChapter();
      await _settledTranscript(container);

      expect(container.read(liveChapterProvider).transcript.hasError, isTrue);
      final archived = (await store.readIndex()).single;
      expect(archived.id, 'room-1');
      expect(archived.transcript, isEmpty);
    });

    // A second chapter started while the first was still transcribing owns the
    // state; the late result must not overwrite it.
    test('a transcript that lands after a reset is dropped', () async {
      final store = tempStore();
      final slow = Completer<String>();
      final container = await hostedChapter(
        transcription: () => slow.future,
        store: store,
      );

      await container.read(liveChapterProvider.notifier).endLiveChapter();
      expect(container.read(liveChapterProvider).transcript.isLoading, isTrue);

      container.read(liveChapterProvider.notifier).reset();
      slow.complete('too late');
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(Duration.zero);
      }

      final state = container.read(liveChapterProvider);
      expect(state.model, isNull);
      expect(state.transcript.value, isNot('too late'));
      // It was still archived, so the recording is not lost.
      expect((await store.readIndex()).single.transcript, 'too late');
    });
  });

  test('reset clears the chapter', () async {
    final container = await joinedAsListener();
    expect(container.read(liveChapterProvider).model, isNotNull);

    container.read(liveChapterProvider.notifier).reset();

    expect(container.read(liveChapterProvider).model, isNull);
  });
}

Future<void> _settledTranscript(ProviderContainer container) async {
  for (var i = 0; i < 200; i++) {
    if (!container.read(liveChapterProvider).transcript.isLoading) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('transcription never settled');
}
