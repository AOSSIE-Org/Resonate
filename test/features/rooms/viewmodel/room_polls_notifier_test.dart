import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/viewmodel/room_chat_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/room_polls_notifier.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

const _roomId = 'room-1';
const _pollChannel = 'databases.$masterDatabaseId.tables.$pollsTableId.rows';
const _voteChannel =
    'databases.$masterDatabaseId.tables.$pollVotesTableId.rows';
const _chatChannel =
    'databases.$masterDatabaseId.tables.$chatMessagesTableId.rows';

Row _pollRow({
  String id = 'p1',
  String roomId = _roomId,
  String question = 'Q?',
  List<String> options = const ['A', 'B'],
  String createdBy = 'me',
  bool isClosed = false,
}) =>
    buildRow(
      id: id,
      tableId: pollsTableId,
      databaseId: masterDatabaseId,
      data: {
        'roomId': roomId,
        'question': question,
        'options': options,
        'createdBy': createdBy,
        'isClosed': isClosed,
      },
    );

Row _voteRow({
  String id = 'v1',
  String pollId = 'p1',
  String roomId = _roomId,
  String uid = 'me',
  int optionIndex = 0,
}) =>
    buildRow(
      id: id,
      tableId: pollVotesTableId,
      databaseId: masterDatabaseId,
      data: {
        'pollId': pollId,
        'roomId': roomId,
        'uid': uid,
        'optionIndex': optionIndex,
      },
    );

RealtimeMessage _pollEvent({
  required String action,
  String id = 'p1',
  String roomId = _roomId,
  String question = 'Q?',
  List<String> options = const ['A', 'B'],
  String createdBy = 'me',
  bool isClosed = false,
}) =>
    RealtimeMessage(
      events: ['$_pollChannel.$id.$action'],
      payload: {
        '\$id': id,
        'roomId': roomId,
        'question': question,
        'options': options,
        'createdBy': createdBy,
        'isClosed': isClosed,
      },
      channels: [_pollChannel],
      timestamp: DateTime.now().toIso8601String(),
    );

RealtimeMessage _voteEvent({
  required String action,
  String id = 'v1',
  String pollId = 'p1',
  String roomId = _roomId,
  String uid = 'other',
  int optionIndex = 0,
}) =>
    RealtimeMessage(
      events: ['$_voteChannel.$id.$action'],
      payload: {
        '\$id': id,
        'pollId': pollId,
        'roomId': roomId,
        'uid': uid,
        'optionIndex': optionIndex,
      },
      channels: [_voteChannel],
      timestamp: DateTime.now().toIso8601String(),
    );

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockFunctions functions;
  late MockRealtimeSubscription pollSubscription;
  late MockRealtimeSubscription voteSubscription;
  late MockRealtimeSubscription chatSubscription;
  late StreamController<RealtimeMessage> pollEvents;
  late StreamController<RealtimeMessage> voteEvents;
  late StreamController<RealtimeMessage> chatEvents;
  // Mutable backing rows so per-test data (and mid-test changes, e.g. the 409
  // reconciliation reload) don't need re-stubbing.
  late List<Row> pollRows;
  late List<Row> voteRows;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    functions = MockFunctions();
    pollSubscription = MockRealtimeSubscription();
    voteSubscription = MockRealtimeSubscription();
    chatSubscription = MockRealtimeSubscription();
    pollEvents = StreamController<RealtimeMessage>.broadcast();
    voteEvents = StreamController<RealtimeMessage>.broadcast();
    chatEvents = StreamController<RealtimeMessage>.broadcast();
    pollRows = [];
    voteRows = [];

    when(pollSubscription.stream).thenAnswer((_) => pollEvents.stream);
    when(pollSubscription.close).thenReturn(() async {});
    when(voteSubscription.stream).thenAnswer((_) => voteEvents.stream);
    when(voteSubscription.close).thenReturn(() async {});
    when(chatSubscription.stream).thenAnswer((_) => chatEvents.stream);
    when(chatSubscription.close).thenReturn(() async {});
    when(realtime.subscribe([_pollChannel])).thenReturn(pollSubscription);
    when(realtime.subscribe([_voteChannel])).thenReturn(voteSubscription);
    when(realtime.subscribe([_chatChannel])).thenReturn(chatSubscription);

    when(tables.listRows(
      databaseId: masterDatabaseId,
      tableId: pollsTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: pollRows.length, rows: pollRows));
    when(tables.listRows(
      databaseId: masterDatabaseId,
      tableId: pollVotesTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: voteRows.length, rows: voteRows));

    // Chat provider collaborators (used by the createPoll announcement path).
    when(tables.listRows(
      databaseId: masterDatabaseId,
      tableId: chatMessagesTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: 0, rows: []));
    when(tables.getRow(
      databaseId: masterDatabaseId,
      tableId: chatMessageReplyTableId,
      rowId: anyNamed('rowId'),
    )).thenThrow(AppwriteException('not found', 404));
  });

  tearDown(() async {
    await pollEvents.close();
    await voteEvents.close();
    await chatEvents.close();
  });

  Future<ProviderContainer> install() => installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        realtime: realtime,
        functions: functions,
      );

  // Reads (and keeps alive) the polls provider until its first build is done.
  Future<ProviderContainer> installAndBuild() async {
    final container = await install();
    container.listen(roomPollsProvider(_roomId), (_, _) {});
    await container.read(roomPollsProvider(_roomId).future);
    return container;
  }

  Future<void> flushStreams() => Future<void>.delayed(Duration.zero);

  group('RoomPollsNotifier build', () {
    test('loads polls and votes into state', () async {
      pollRows = [
        _pollRow(id: 'p1', question: 'First?'),
        _pollRow(id: 'p2', question: 'Second?', isClosed: true),
      ];
      voteRows = [_voteRow(id: 'v1', pollId: 'p1', uid: 'other')];

      final container = await installAndBuild();
      final state = container.read(roomPollsProvider(_roomId)).value!;

      expect(state.polls, hasLength(2));
      expect(state.pollById('p1')!.question, 'First?');
      expect(state.pollById('p1')!.options, ['A', 'B']);
      expect(state.pollById('p1')!.isClosed, isFalse);
      expect(state.pollById('p2')!.isClosed, isTrue);
      expect(state.votes, hasLength(1));
      expect(state.votes.single.voteId, 'v1');
      expect(state.votes.single.uid, 'other');
    });
  });

  group('RoomPollsNotifier poll stream', () {
    test('create event appends a new poll', () async {
      pollRows = [_pollRow(id: 'p1')];
      final container = await installAndBuild();

      pollEvents.add(_pollEvent(action: 'create', id: 'p2', question: 'New?'));
      await flushStreams();

      final state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.polls, hasLength(2));
      expect(state.pollById('p2')!.question, 'New?');
    });

    test('create event for a known pollId upserts in place', () async {
      pollRows = [_pollRow(id: 'p1', question: 'Old?')];
      final container = await installAndBuild();

      pollEvents.add(_pollEvent(action: 'create', id: 'p1', question: 'New?'));
      await flushStreams();

      final state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.polls, hasLength(1));
      expect(state.pollById('p1')!.question, 'New?');
    });

    test('update event flips isClosed', () async {
      pollRows = [_pollRow(id: 'p1', isClosed: false)];
      final container = await installAndBuild();

      pollEvents.add(_pollEvent(action: 'update', id: 'p1', isClosed: true));
      await flushStreams();

      final state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.polls, hasLength(1));
      expect(state.pollById('p1')!.isClosed, isTrue);
    });

    test('delete event removes the poll and its votes only', () async {
      pollRows = [_pollRow(id: 'p1'), _pollRow(id: 'p2')];
      voteRows = [
        _voteRow(id: 'v1', pollId: 'p1', uid: 'other'),
        _voteRow(id: 'v2', pollId: 'p2', uid: 'other'),
      ];
      final container = await installAndBuild();

      pollEvents.add(_pollEvent(action: 'delete', id: 'p1'));
      await flushStreams();

      final state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.polls, hasLength(1));
      expect(state.pollById('p1'), isNull);
      expect(state.votes, hasLength(1));
      expect(state.votes.single.voteId, 'v2');
    });
  });

  group('RoomPollsNotifier vote stream', () {
    test('create event appends a new vote', () async {
      pollRows = [_pollRow(id: 'p1')];
      final container = await installAndBuild();

      voteEvents.add(
        _voteEvent(action: 'create', id: 'v9', uid: 'other', optionIndex: 1),
      );
      await flushStreams();

      final state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.votes, hasLength(1));
      expect(state.votes.single.voteId, 'v9');
      expect(state.votes.single.optionIndex, 1);
    });

    test('create and update events for a known voteId upsert in place',
        () async {
      pollRows = [_pollRow(id: 'p1')];
      voteRows = [_voteRow(id: 'v1', uid: 'other', optionIndex: 0)];
      final container = await installAndBuild();

      voteEvents.add(
        _voteEvent(action: 'create', id: 'v1', uid: 'other', optionIndex: 1),
      );
      await flushStreams();
      var state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.votes, hasLength(1));
      expect(state.votes.single.optionIndex, 1);

      voteEvents.add(
        _voteEvent(action: 'update', id: 'v1', uid: 'other', optionIndex: 0),
      );
      await flushStreams();
      state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.votes, hasLength(1));
      expect(state.votes.single.optionIndex, 0);
    });

    test('delete event removes the vote', () async {
      pollRows = [_pollRow(id: 'p1')];
      voteRows = [_voteRow(id: 'v1', uid: 'other')];
      final container = await installAndBuild();

      voteEvents.add(_voteEvent(action: 'delete', id: 'v1', uid: 'other'));
      await flushStreams();

      final state = container.read(roomPollsProvider(_roomId)).value!;
      expect(state.votes, isEmpty);
    });
  });

  group('RoomPollsNotifier vote', () {
    test(
        'first vote inserts optimistically, resolves true, and a repeat '
        'same-option vote is a no-op', () async {
      pollRows = [_pollRow(id: 'p1')];
      final gate = Completer<Row>();
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) => gate.future);

      final container = await installAndBuild();
      final notifier = container.read(roomPollsProvider(_roomId).notifier);

      final pending = notifier.vote(pollId: 'p1', optionIndex: 1);

      // Optimistic: visible before the repository write completes.
      final optimistic = container
          .read(roomPollsProvider(_roomId))
          .value!
          .voteByUser('p1', 'me');
      expect(optimistic, isNotNull);
      expect(optimistic!.optionIndex, 1);

      gate.complete(_voteRow(id: optimistic.voteId, optionIndex: 1));
      expect(await pending, isTrue);

      // Voting the same option again short-circuits without a second write.
      expect(await notifier.vote(pollId: 'p1', optionIndex: 1), isTrue);
      verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).called(1);
    });

    test('generic castVote failure rolls the optimistic vote back', () async {
      pollRows = [_pollRow(id: 'p1')];
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenThrow(Exception('network down'));

      final container = await installAndBuild();
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .vote(pollId: 'p1', optionIndex: 0);

      expect(ok, isFalse);
      expect(container.read(roomPollsProvider(_roomId)).value!.votes, isEmpty);
    });

    test('409 on castVote reconciles votes to server truth', () async {
      pollRows = [_pollRow(id: 'p1')];
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenThrow(AppwriteException('duplicate', 409));

      final container = await installAndBuild();

      // The server already holds a vote from another session; the
      // reconciliation reload (loadVotesForPoll) must surface it.
      voteRows = [_voteRow(id: 'server-v', uid: 'me', optionIndex: 0)];

      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .vote(pollId: 'p1', optionIndex: 1);

      expect(ok, isFalse);
      final votes = container.read(roomPollsProvider(_roomId)).value!.votes;
      expect(votes, hasLength(1));
      expect(votes.single.voteId, 'server-v');
      expect(votes.single.optionIndex, 0);
    });

    test('changing an existing vote uses changeVote optimistically', () async {
      pollRows = [_pollRow(id: 'p1')];
      voteRows = [_voteRow(id: 'v1', uid: 'me', optionIndex: 0)];
      final gate = Completer<Row>();
      when(tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: 'v1',
        data: anyNamed('data'),
      )).thenAnswer((_) => gate.future);

      final container = await installAndBuild();
      final pending = container
          .read(roomPollsProvider(_roomId).notifier)
          .vote(pollId: 'p1', optionIndex: 1);

      // Optimistic flip before the write resolves.
      expect(
        container
            .read(roomPollsProvider(_roomId))
            .value!
            .voteByUser('p1', 'me')!
            .optionIndex,
        1,
      );

      gate.complete(_voteRow(id: 'v1', uid: 'me', optionIndex: 1));
      expect(await pending, isTrue);

      verifyNever(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ));
      final captured = verify(tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: 'v1',
        data: captureAnyNamed('data'),
      )).captured;
      expect(captured.single, {'optionIndex': 1});
    });

    test('changeVote failure rolls back to the original option', () async {
      pollRows = [_pollRow(id: 'p1')];
      voteRows = [_voteRow(id: 'v1', uid: 'me', optionIndex: 0)];
      when(tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: 'v1',
        data: anyNamed('data'),
      )).thenThrow(Exception('network down'));

      final container = await installAndBuild();
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .vote(pollId: 'p1', optionIndex: 1);

      expect(ok, isFalse);
      expect(
        container
            .read(roomPollsProvider(_roomId))
            .value!
            .voteByUser('p1', 'me')!
            .optionIndex,
        0,
      );
    });

    test('closed or unknown poll returns false without repository calls',
        () async {
      pollRows = [_pollRow(id: 'p1', isClosed: true)];
      final container = await installAndBuild();
      final notifier = container.read(roomPollsProvider(_roomId).notifier);

      expect(await notifier.vote(pollId: 'p1', optionIndex: 0), isFalse);
      expect(await notifier.vote(pollId: 'nope', optionIndex: 0), isFalse);

      verifyNever(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ));
      verifyNever(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ));
    });

    test('invalid optionIndex returns false without repository calls',
        () async {
      pollRows = [_pollRow(id: 'p1', options: ['A', 'B'])];
      final container = await installAndBuild();
      final notifier = container.read(roomPollsProvider(_roomId).notifier);

      expect(await notifier.vote(pollId: 'p1', optionIndex: -1), isFalse);
      expect(await notifier.vote(pollId: 'p1', optionIndex: 2), isFalse);

      verifyNever(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ));
      expect(container.read(roomPollsProvider(_roomId)).value!.votes, isEmpty);
    });
  });

  group('RoomPollsNotifier closePoll', () {
    test('closes optimistically and resolves true on success', () async {
      pollRows = [_pollRow(id: 'p1', isClosed: false)];
      final gate = Completer<Row>();
      when(tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: 'p1',
        data: anyNamed('data'),
      )).thenAnswer((_) => gate.future);

      final container = await installAndBuild();
      final pending =
          container.read(roomPollsProvider(_roomId).notifier).closePoll('p1');

      expect(
        container
            .read(roomPollsProvider(_roomId))
            .value!
            .pollById('p1')!
            .isClosed,
        isTrue,
      );

      gate.complete(_pollRow(id: 'p1', isClosed: true));
      expect(await pending, isTrue);

      final captured = verify(tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: 'p1',
        data: captureAnyNamed('data'),
      )).captured;
      expect(captured.single, {'isClosed': true});
    });

    test('failure rolls the poll back to open', () async {
      pollRows = [_pollRow(id: 'p1', isClosed: false)];
      when(tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: 'p1',
        data: anyNamed('data'),
      )).thenThrow(Exception('network down'));

      final container = await installAndBuild();
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .closePoll('p1');

      expect(ok, isFalse);
      expect(
        container
            .read(roomPollsProvider(_roomId))
            .value!
            .pollById('p1')!
            .isClosed,
        isFalse,
      );
    });

    test('already-closed poll returns true without a repository call',
        () async {
      pollRows = [_pollRow(id: 'p1', isClosed: true)];
      final container = await installAndBuild();

      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .closePoll('p1');

      expect(ok, isTrue);
      verifyNever(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: pollsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ));
    });

    test('unknown pollId returns false', () async {
      final container = await installAndBuild();
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .closePoll('nope');
      expect(ok, isFalse);
    });
  });

  group('RoomPollsNotifier createPoll', () {
    // createPoll cross-calls roomChatProvider(roomId, roomName, false); the
    // chat provider must already be built or sendMessage no-ops on null state.
    Future<ProviderContainer> installWithChat() async {
      final container = await installAndBuild();
      final chatKey = roomChatProvider(_roomId, 'Room 1', false);
      container.listen(chatKey, (_, _) {});
      await container.read(chatKey.future);
      return container;
    }

    test(
        'creates the poll row, inserts it optimistically, and announces it '
        'through chat with the pollId attached', () async {
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => _pollRow(id: 'created'));
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: chatMessagesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => buildRow(
            id: 'msg',
            tableId: chatMessagesTableId,
            databaseId: masterDatabaseId,
            data: const {},
          ));

      final container = await installWithChat();
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .createPoll(
            question: 'Which one?',
            options: ['A', 'B'],
            roomName: 'Room 1',
          );

      expect(ok, isTrue);

      final polls = container.read(roomPollsProvider(_roomId)).value!.polls;
      expect(polls, hasLength(1));
      expect(polls.single.question, 'Which one?');
      expect(polls.single.options, ['A', 'B']);
      expect(polls.single.createdBy, 'me');

      final captured = verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: captureAnyNamed('rowId'),
        data: captureAnyNamed('data'),
      )).captured;
      expect(captured[0], polls.single.pollId);
      expect((captured[1] as Map)['question'], 'Which one?');
      expect((captured[1] as Map)['roomId'], _roomId);

      // The chat announcement carries the pollId and the question as content.
      final messages = container
          .read(roomChatProvider(_roomId, 'Room 1', false))
          .value!
          .messages;
      expect(messages, hasLength(1));
      expect(messages.single.content, 'Which one?');
      expect(messages.single.pollId, polls.single.pollId);
      expect(messages.single.status, RoomMessageStatus.sent);
    });

    test('returns true even when the chat announcement fails to send',
        () async {
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => _pollRow(id: 'created'));
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: chatMessagesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenThrow(Exception('network down'));

      final container = await installWithChat();
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .createPoll(
            question: 'Which one?',
            options: ['A', 'B'],
            roomName: 'Room 1',
          );

      // Poll row succeeded, so createPoll reports success; the failed
      // announcement stays in chat with the usual tap-to-retry.
      expect(ok, isTrue);
      expect(
        container.read(roomPollsProvider(_roomId)).value!.polls,
        hasLength(1),
      );

      final messages = container
          .read(roomChatProvider(_roomId, 'Room 1', false))
          .value!
          .messages;
      expect(messages, hasLength(1));
      expect(messages.single.status, RoomMessageStatus.failed);
      expect(messages.single.pollId, isNotNull);
    });

    test('returns false and sends no chat message when the poll row fails',
        () async {
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenThrow(AppwriteException('denied', 401));

      final container = await installWithChat();
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .createPoll(
            question: 'Which one?',
            options: ['A', 'B'],
            roomName: 'Room 1',
          );

      expect(ok, isFalse);
      expect(container.read(roomPollsProvider(_roomId)).value!.polls, isEmpty);
      verifyNever(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: chatMessagesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ));
      expect(
        container
            .read(roomChatProvider(_roomId, 'Room 1', false))
            .value!
            .messages,
        isEmpty,
      );
    });

    test(
        'works on a cold provider whose first build has not completed '
        '(bootstrap regression)', () async {
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => _pollRow(id: 'created'));
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: chatMessagesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => buildRow(
            id: 'msg',
            tableId: chatMessagesTableId,
            databaseId: masterDatabaseId,
            data: const {},
          ));

      final container = await install();
      final chatKey = roomChatProvider(_roomId, 'Room 1', false);
      container.listen(chatKey, (_, _) {});
      await container.read(chatKey.future);

      // Mirror the fixed CreatePollSheet: the sheet watches the provider but
      // the host can submit before the first build completes — no awaited
      // future here.
      container.listen(roomPollsProvider(_roomId), (_, _) {});
      final ok = await container
          .read(roomPollsProvider(_roomId).notifier)
          .createPoll(
            question: 'Cold start?',
            options: ['A', 'B'],
            roomName: 'Room 1',
          );

      expect(ok, isTrue);
      verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).called(1);
      final messages = container.read(chatKey).value!.messages;
      expect(messages, hasLength(1));
      expect(messages.single.pollId, isNotNull);
    });
  });

  group('RoomPollsNotifier race hardening', () {
    test('events arriving during the initial load are buffered and replayed',
        () async {
      final gate = Completer<void>();
      when(tables.listRows(
        databaseId: masterDatabaseId,
        tableId: pollsTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async {
        await gate.future;
        return RowList(total: 1, rows: [_pollRow(id: 'p1')]);
      });

      final container = await install();
      container.listen(roomPollsProvider(_roomId), (_, _) {});
      final pendingState = container.read(roomPollsProvider(_roomId).future);
      await flushStreams();

      // Lands while loadPolls is still blocked on the gate.
      voteEvents.add(
        _voteEvent(action: 'create', id: 'v9', uid: 'other', optionIndex: 1),
      );
      await flushStreams();

      gate.complete();
      final state = await pendingState;
      expect(state.polls, hasLength(1));
      expect(state.votes.map((v) => v.voteId), contains('v9'));
    });

    test(
        'changeVote failure does not clobber newer realtime vote data '
        '(conditional rollback)', () async {
      pollRows = [
        _pollRow(id: 'p1', options: ['A', 'B', 'C'])
      ];
      voteRows = [_voteRow(id: 'v1', uid: 'me', optionIndex: 0)];
      final gate = Completer<void>();
      when(tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: 'v1',
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await gate.future;
        throw Exception('network down');
      });

      final container = await installAndBuild();
      final pending = container
          .read(roomPollsProvider(_roomId).notifier)
          .vote(pollId: 'p1', optionIndex: 1);
      await flushStreams();

      // Newer truth arrives (e.g. this user changed the vote on another
      // device) while our write is still in flight.
      voteEvents.add(
        _voteEvent(action: 'update', id: 'v1', uid: 'me', optionIndex: 2),
      );
      await flushStreams();

      gate.complete();
      expect(await pending, isFalse);
      expect(
        container
            .read(roomPollsProvider(_roomId))
            .value!
            .voteByUser('p1', 'me')!
            .optionIndex,
        2,
      );
    });

    test('a second tap while a vote write is in flight is dropped quietly',
        () async {
      pollRows = [
        _pollRow(id: 'p1', options: ['A', 'B'])
      ];
      final gate = Completer<Row>();
      when(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) => gate.future);

      final container = await installAndBuild();
      final notifier = container.read(roomPollsProvider(_roomId).notifier);

      final first = notifier.vote(pollId: 'p1', optionIndex: 0);
      final second = notifier.vote(pollId: 'p1', optionIndex: 1);

      gate.complete(_voteRow(id: 'ignored', optionIndex: 0));
      expect(await first, isTrue);
      expect(await second, isTrue);

      verify(tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).called(1);
      verifyNever(tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: pollVotesTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ));
    });
  });
}
