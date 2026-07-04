import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/rooms/model/poll.dart';
import 'package:resonate/features/rooms/model/poll_vote.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_polls_repository.g.dart';

@Riverpod(keepAlive: true)
RoomPollsRepository roomPollsRepository(Ref ref) => RoomPollsRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
);

class RoomPollsRepository {
  RoomPollsRepository({
    required TablesDB tables,
    required Realtime realtime,
  }) : _tables = tables,
       _realtime = realtime;

  final TablesDB _tables;
  final Realtime _realtime;

  static const _pageSize = 100;

  Future<List<Poll>> loadPolls(String roomId) async {
    final result = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: pollsTableId,
      queries: [
        Query.equal('roomId', roomId),
        Query.orderAsc(r'$createdAt'),
        Query.limit(_pageSize),
      ],
    );
    return result.rows
        .map((row) => Poll.fromJson({...row.data, r'$id': row.$id}))
        .toList();
  }

  Future<List<PollVote>> loadVotes(String roomId) =>
      _loadVotesWhere(Query.equal('roomId', roomId));

  Future<List<PollVote>> loadVotesForPoll(String pollId) =>
      _loadVotesWhere(Query.equal('pollId', pollId));

  // Votes can exceed one page in busy rooms, so follow the cursor.
  Future<List<PollVote>> _loadVotesWhere(String filter) async {
    final votes = <PollVote>[];
    String? cursor;
    while (true) {
      final result = await _tables.listRows(
        databaseId: masterDatabaseId,
        tableId: pollVotesTableId,
        queries: [
          filter,
          Query.limit(_pageSize),
          if (cursor != null) Query.cursorAfter(cursor),
        ],
      );
      votes.addAll(
        result.rows.map(
          (row) => PollVote.fromJson({...row.data, r'$id': row.$id}),
        ),
      );
      if (result.rows.length < _pageSize) break;
      cursor = result.rows.last.$id;
    }
    return votes;
  }

  Future<void> createPoll(Poll poll) async {
    await _tables.createRow(
      databaseId: masterDatabaseId,
      tableId: pollsTableId,
      rowId: poll.pollId,
      data: poll.toJsonForUpload(),
    );
  }

  Future<void> closePoll(String pollId) async {
    await _tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: pollsTableId,
      rowId: pollId,
      data: {'isClosed': true},
    );
  }

  Future<void> castVote(PollVote vote) async {
    await _tables.createRow(
      databaseId: masterDatabaseId,
      tableId: pollVotesTableId,
      rowId: vote.voteId,
      data: vote.toJsonForUpload(),
    );
  }

  Future<void> changeVote(PollVote vote) async {
    await _tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: pollVotesTableId,
      rowId: vote.voteId,
      data: {'optionIndex': vote.optionIndex},
    );
  }

  Stream<({Poll poll, String action})> pollStream(String roomId) {
    final channel = 'databases.$masterDatabaseId.tables.$pollsTableId.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<({Poll poll, String action})>();

    final sub = subscription.stream.listen((data) {
      if (data.payload.isEmpty || data.payload['roomId'] != roomId) return;

      final docId = data.payload['\$id'] as String;
      final action = data.events.first.substring(
        channel.length + 1 + docId.length + 1,
      );

      try {
        controller.add((poll: Poll.fromJson(data.payload), action: action));
      } catch (_) {}
    });

    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }

  Stream<({PollVote vote, String action})> voteStream(String roomId) {
    final channel = 'databases.$masterDatabaseId.tables.$pollVotesTableId.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<({PollVote vote, String action})>();

    final sub = subscription.stream.listen((data) {
      if (data.payload.isEmpty || data.payload['roomId'] != roomId) return;

      final docId = data.payload['\$id'] as String;
      final action = data.events.first.substring(
        channel.length + 1 + docId.length + 1,
      );

      try {
        controller.add(
          (vote: PollVote.fromJson(data.payload), action: action),
        );
      } catch (_) {}
    });

    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }
}
