import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/rooms/data/repositories/room_polls_repository.dart';
import 'package:resonate/features/rooms/model/poll.dart';
import 'package:resonate/features/rooms/model/poll_vote.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

// Builds a poll row payload matching Poll.fromJson (without $id — loadPolls
// merges the row $id in itself). Nullable params allow testing the
// options/isClosed null-default path.
Map<String, dynamic> pollData({
  String roomId = 'room-1',
  String question = 'Favorite color?',
  List<String>? options = const ['red', 'blue'],
  String createdBy = 'me',
  bool? isClosed = false,
}) => {
  'roomId': roomId,
  'question': question,
  'options': options,
  'createdBy': createdBy,
  'isClosed': isClosed,
};

Map<String, dynamic> voteData({
  String pollId = 'poll-1',
  String roomId = 'room-1',
  String uid = 'me',
  int optionIndex = 0,
}) => {
  'pollId': pollId,
  'roomId': roomId,
  'uid': uid,
  'optionIndex': optionIndex,
};

Row pollRow({String id = 'poll-1', Map<String, dynamic>? data}) => buildRow(
  id: id,
  tableId: pollsTableId,
  databaseId: masterDatabaseId,
  data: data ?? pollData(),
);

Row voteRow({String id = 'vote-1', Map<String, dynamic>? data}) => buildRow(
  id: id,
  tableId: pollVotesTableId,
  databaseId: masterDatabaseId,
  data: data ?? voteData(),
);

Poll fakePoll({
  String pollId = 'poll-1',
  String roomId = 'room-1',
  String question = 'Favorite color?',
  List<String> options = const ['red', 'blue'],
  String createdBy = 'me',
  bool isClosed = false,
}) => Poll(
  pollId: pollId,
  roomId: roomId,
  question: question,
  options: options,
  createdBy: createdBy,
  isClosed: isClosed,
);

PollVote fakeVote({
  String voteId = 'vote-1',
  String pollId = 'poll-1',
  String roomId = 'room-1',
  String uid = 'me',
  int optionIndex = 1,
}) => PollVote(
  voteId: voteId,
  pollId: pollId,
  roomId: roomId,
  uid: uid,
  optionIndex: optionIndex,
);

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late RoomPollsRepository repo;

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    repo = RoomPollsRepository(tables: tables, realtime: realtime);
  });

  group('loadPolls', () {
    test('maps rows to polls with the row \$id as pollId and queries '
        'roomId/orderAsc/limit', () async {
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [pollRow(id: 'p1'), pollRow(id: 'p2')],
        ),
      );

      final polls = await repo.loadPolls('room-1');

      expect(polls, hasLength(2));
      expect(polls[0].pollId, 'p1');
      expect(polls[1].pollId, 'p2');
      expect(polls[0].roomId, 'room-1');

      final queries = verify(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollsTableId,
          queries: captureAnyNamed('queries'),
        ),
      ).captured.single as List<String>;
      expect(queries, [
        Query.equal('roomId', 'room-1'),
        Query.orderAsc(r'$createdAt'),
        Query.limit(100),
      ]);
    });

    test('defaults null options to [] and null isClosed to false', () async {
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 1,
          rows: [
            pollRow(id: 'p1', data: pollData(options: null, isClosed: null)),
          ],
        ),
      );

      final polls = await repo.loadPolls('room-1');

      expect(polls, hasLength(1));
      expect(polls.single.options, isEmpty);
      expect(polls.single.isClosed, isFalse);
    });
  });

  group('loadVotes', () {
    test('single page maps rows to votes with the row \$id as voteId',
        () async {
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(
          total: 2,
          rows: [voteRow(id: 'v1'), voteRow(id: 'v2')],
        ),
      );

      final votes = await repo.loadVotes('room-1');

      expect(votes, hasLength(2));
      expect(votes[0].voteId, 'v1');
      expect(votes[1].voteId, 'v2');

      final queries = verify(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          queries: captureAnyNamed('queries'),
        ),
      ).captured.single as List<String>;
      expect(queries, [
        Query.equal('roomId', 'room-1'),
        Query.limit(100),
      ]);
    });

    test('follows the cursor across pages and concatenates results', () async {
      final firstPage = List.generate(100, (i) => voteRow(id: 'v$i'));
      var call = 0;
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async {
        call++;
        return call == 1
            ? RowList(total: 101, rows: firstPage)
            : RowList(total: 101, rows: [voteRow(id: 'v-last')]);
      });

      final votes = await repo.loadVotes('room-1');

      expect(votes, hasLength(101));
      expect(votes.first.voteId, 'v0');
      expect(votes.last.voteId, 'v-last');

      final captured = verify(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          queries: captureAnyNamed('queries'),
        ),
      ).captured;
      expect(captured, hasLength(2));
      expect(captured[0], [
        Query.equal('roomId', 'room-1'),
        Query.limit(100),
      ]);
      // Second call resumes after the last row of the first page.
      expect(captured[1], [
        Query.equal('roomId', 'room-1'),
        Query.limit(100),
        Query.cursorAfter('v99'),
      ]);
    });
  });

  group('loadVotesForPoll', () {
    test('filters by pollId', () async {
      when(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer(
        (_) async => RowList(total: 1, rows: [voteRow(id: 'v1')]),
      );

      final votes = await repo.loadVotesForPoll('poll-1');

      expect(votes, hasLength(1));
      expect(votes.single.pollId, 'poll-1');

      final queries = verify(
        tables.listRows(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          queries: captureAnyNamed('queries'),
        ),
      ).captured.single as List<String>;
      expect(queries, [
        Query.equal('pollId', 'poll-1'),
        Query.limit(100),
      ]);
    });
  });

  group('createPoll', () {
    test('creates the row keyed by pollId with the upload json (no \$id)',
        () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => pollRow());

      final poll = fakePoll(pollId: 'poll-1');
      await repo.createPoll(poll);

      final data = verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: pollsTableId,
          rowId: 'poll-1',
          data: captureAnyNamed('data'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(data.containsKey(r'$id'), isFalse);
      expect(
        data.keys,
        unorderedEquals(
          ['roomId', 'question', 'options', 'createdBy', 'isClosed'],
        ),
      );
      expect(data['roomId'], 'room-1');
      expect(data['question'], 'Favorite color?');
      expect(data['options'], ['red', 'blue']);
      expect(data['createdBy'], 'me');
      expect(data['isClosed'], false);
    });
  });

  group('castVote', () {
    test('creates the row keyed by voteId with the upload json (no \$id)',
        () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => voteRow());

      final vote = fakeVote(voteId: 'vote-1');
      await repo.castVote(vote);

      final data = verify(
        tables.createRow(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          rowId: 'vote-1',
          data: captureAnyNamed('data'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(data.containsKey(r'$id'), isFalse);
      expect(
        data.keys,
        unorderedEquals(['pollId', 'roomId', 'uid', 'optionIndex']),
      );
      expect(data['optionIndex'], 1);
    });
  });

  group('changeVote', () {
    test('updates only the optionIndex attribute', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => voteRow());

      await repo.changeVote(fakeVote(voteId: 'vote-1', optionIndex: 2));

      verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: pollVotesTableId,
          rowId: 'vote-1',
          data: {'optionIndex': 2},
        ),
      ).called(1);
    });
  });

  group('closePoll', () {
    test('updates only the isClosed attribute', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => pollRow());

      await repo.closePoll('poll-1');

      verify(
        tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: pollsTableId,
          rowId: 'poll-1',
          data: {'isClosed': true},
        ),
      ).called(1);
    });
  });

  group('pollStream', () {
    late MockRealtimeSubscription sub;
    late StreamController<RealtimeMessage> controller;
    late String channel;
    late int closeCalls;

    setUp(() {
      sub = MockRealtimeSubscription();
      controller = StreamController<RealtimeMessage>.broadcast();
      channel = 'databases.$masterDatabaseId.tables.$pollsTableId.rows';
      closeCalls = 0;
      when(realtime.subscribe([channel])).thenReturn(sub);
      when(sub.stream).thenAnswer((_) => controller.stream);
      when(sub.close).thenReturn(() async {
        closeCalls++;
      });
    });

    RealtimeMessage event({
      required String docId,
      required String action,
      Map<String, dynamic>? payload,
    }) => RealtimeMessage(
      events: ['$channel.$docId.$action'],
      // Realtime payload carries the row $id the repo reads before parsing.
      payload: {'\$id': docId, ...(payload ?? pollData())},
      channels: [channel],
      timestamp: DateTime.now().toIso8601String(),
    );

    test('filters empty and mismatched roomId payloads', () async {
      final emitted = <({Poll poll, String action})>[];
      final streamSub = repo.pollStream('room-1').listen(emitted.add);

      // Empty payload -> filtered.
      controller.add(RealtimeMessage(
        events: ['$channel.x.create'],
        payload: const {},
        channels: [channel],
        timestamp: DateTime.now().toIso8601String(),
      ));
      // Mismatched roomId -> filtered.
      controller.add(event(
        docId: 'y',
        action: 'create',
        payload: pollData(roomId: 'other-room'),
      ));
      // Matching roomId -> emitted.
      controller.add(event(docId: 'z', action: 'create'));
      await pumpEventQueue();

      expect(emitted, hasLength(1));
      expect(emitted.single.action, 'create');
      expect(emitted.single.poll.pollId, 'z');
      expect(emitted.single.poll.roomId, 'room-1');

      await streamSub.cancel();
    });

    test('parses the action substring after the doc id in events.first',
        () async {
      final emitted = <({Poll poll, String action})>[];
      final streamSub = repo.pollStream('room-1').listen(emitted.add);

      // Doc ids of different lengths exercise the substring offset math.
      controller.add(event(docId: 'a', action: 'create'));
      controller.add(event(docId: 'poll-longer-id', action: 'update'));
      await pumpEventQueue();

      expect(emitted.map((e) => e.action), ['create', 'update']);
      expect(emitted.map((e) => e.poll.pollId), ['a', 'poll-longer-id']);
      verify(realtime.subscribe([channel])).called(1);

      await streamSub.cancel();
    });

    test('cancelling the stream closes the realtime subscription', () async {
      final streamSub = repo.pollStream('room-1').listen((_) {});

      await streamSub.cancel();

      expect(closeCalls, 1);
    });
  });

  group('voteStream', () {
    late MockRealtimeSubscription sub;
    late StreamController<RealtimeMessage> controller;
    late String channel;
    late int closeCalls;

    setUp(() {
      sub = MockRealtimeSubscription();
      controller = StreamController<RealtimeMessage>.broadcast();
      channel = 'databases.$masterDatabaseId.tables.$pollVotesTableId.rows';
      closeCalls = 0;
      when(realtime.subscribe([channel])).thenReturn(sub);
      when(sub.stream).thenAnswer((_) => controller.stream);
      when(sub.close).thenReturn(() async {
        closeCalls++;
      });
    });

    RealtimeMessage event({
      required String docId,
      required String action,
      Map<String, dynamic>? payload,
    }) => RealtimeMessage(
      events: ['$channel.$docId.$action'],
      payload: {'\$id': docId, ...(payload ?? voteData())},
      channels: [channel],
      timestamp: DateTime.now().toIso8601String(),
    );

    test('filters mismatched roomId and emits typed vote records', () async {
      final emitted = <({PollVote vote, String action})>[];
      final streamSub = repo.voteStream('room-1').listen(emitted.add);

      // Mismatched roomId -> filtered.
      controller.add(event(
        docId: 'v-other',
        action: 'create',
        payload: voteData(roomId: 'other-room'),
      ));
      // Matching roomId -> emitted.
      controller.add(event(docId: 'v1', action: 'create'));
      await pumpEventQueue();

      expect(emitted, hasLength(1));
      expect(emitted.single.action, 'create');
      expect(emitted.single.vote.voteId, 'v1');
      expect(emitted.single.vote.pollId, 'poll-1');

      await streamSub.cancel();
    });

    test('cancelling the stream closes the realtime subscription', () async {
      final streamSub = repo.voteStream('room-1').listen((_) {});

      await streamSub.cancel();

      expect(closeCalls, 1);
    });
  });
}
