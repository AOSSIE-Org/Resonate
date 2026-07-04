import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart' show AppwriteException, ID;
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/data/repositories/room_polls_repository.dart';
import 'package:resonate/features/rooms/model/poll.dart';
import 'package:resonate/features/rooms/model/poll_vote.dart';
import 'package:resonate/features/rooms/model/room_polls_state.dart';
import 'package:resonate/features/rooms/viewmodel/room_chat_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_polls_notifier.g.dart';

@riverpod
class RoomPollsNotifier extends _$RoomPollsNotifier {
  StreamSubscription? _pollSub;
  StreamSubscription? _voteSub;

  // Events that arrive while the initial load is still running are buffered
  // and replayed over the snapshot, so nothing lands in the gap between
  // fetching and subscribing.
  final List<({Poll poll, String action})> _pollBuffer = [];
  final List<({PollVote vote, String action})> _voteBuffer = [];

  // Poll ids with a vote write in flight, to ignore rapid re-taps that would
  // otherwise race the pending create/update.
  final Set<String> _votesInFlight = {};

  @override
  Future<RoomPollsState> build(String roomId) async {
    ref.onDispose(() async {
      await _pollSub?.cancel();
      await _voteSub?.cancel();
    });
    _pollBuffer.clear();
    _voteBuffer.clear();

    final repo = ref.read(roomPollsRepositoryProvider);

    // Subscribe before fetching; the id-based upserts make replay idempotent.
    _pollSub = repo.pollStream(roomId).listen((event) {
      final current = state.value;
      if (current == null) {
        _pollBuffer.add(event);
        return;
      }
      state = AsyncData(_applyPollEvent(current, event));
    });
    _voteSub = repo.voteStream(roomId).listen((event) {
      final current = state.value;
      if (current == null) {
        _voteBuffer.add(event);
        return;
      }
      state = AsyncData(_applyVoteEvent(current, event));
    });

    final polls = await repo.loadPolls(roomId);
    final votes = await repo.loadVotes(roomId);

    var initial = RoomPollsState(polls: polls, votes: votes);
    for (final event in _pollBuffer) {
      initial = _applyPollEvent(initial, event);
    }
    for (final event in _voteBuffer) {
      initial = _applyVoteEvent(initial, event);
    }
    _pollBuffer.clear();
    _voteBuffer.clear();
    return initial;
  }

  RoomPollsState _applyPollEvent(
    RoomPollsState current,
    ({Poll poll, String action}) event,
  ) {
    if (event.action == 'create' || event.action == 'update') {
      // Upsert: a create for a poll we optimistically inserted replaces it.
      final idx = current.polls.indexWhere(
        (p) => p.pollId == event.poll.pollId,
      );
      final List<Poll> polls;
      if (idx >= 0) {
        polls = [...current.polls];
        polls[idx] = event.poll;
      } else {
        polls = [...current.polls, event.poll];
      }
      return current.copyWith(polls: polls);
    }
    if (event.action == 'delete') {
      return current.copyWith(
        polls: current.polls
            .where((p) => p.pollId != event.poll.pollId)
            .toList(),
        votes: current.votes
            .where((v) => v.pollId != event.poll.pollId)
            .toList(),
      );
    }
    return current;
  }

  RoomPollsState _applyVoteEvent(
    RoomPollsState current,
    ({PollVote vote, String action}) event,
  ) {
    if (event.action == 'create' || event.action == 'update') {
      final idx = current.votes.indexWhere(
        (v) => v.voteId == event.vote.voteId,
      );
      final List<PollVote> votes;
      if (idx >= 0) {
        votes = [...current.votes];
        votes[idx] = event.vote;
      } else {
        votes = [...current.votes, event.vote];
      }
      return current.copyWith(votes: votes);
    }
    if (event.action == 'delete') {
      return current.copyWith(
        votes: current.votes
            .where((v) => v.voteId != event.vote.voteId)
            .toList(),
      );
    }
    return current;
  }

  /// Creates the poll row, then announces it through the regular chat
  /// pipeline so it renders inline in chat order with the usual
  /// retry-on-failure UX. Returns false only if the poll row itself failed.
  Future<bool> createPoll({
    required String question,
    required List<String> options,
    required String roomName,
  }) async {
    // Wait for the initial load so the optimistic insert and realtime
    // upserts operate on real state; a load failure doesn't block creation.
    try {
      await future;
    } catch (e) {
      log('polls state unavailable before createPoll: $e');
    }
    if (!ref.mounted) return false;

    final user = ref.read(requireUserProvider);
    final poll = Poll(
      pollId: ID.unique(),
      roomId: roomId,
      question: question,
      options: options,
      createdBy: user.uid,
    );

    try {
      await ref.read(roomPollsRepositoryProvider).createPoll(poll);
    } catch (e) {
      log('createPoll failed: $e');
      return false;
    }
    if (!ref.mounted) return false;

    // Show it immediately; the realtime echo will upsert over this.
    final after = state.value;
    if (after != null && after.pollById(poll.pollId) == null) {
      state = AsyncData(after.copyWith(polls: [...after.polls, poll]));
    }

    // Make sure the chat state is built before sending, otherwise the
    // announcement would be dropped without even a retryable message.
    final chatKey = roomChatProvider(roomId, roomName, false);
    try {
      await ref.read(chatKey.future);
    } catch (e) {
      log('chat state unavailable for poll announcement: $e');
    }
    if (!ref.mounted) return true;

    final sent = await ref
        .read(chatKey.notifier)
        .sendMessage(
          roomId: roomId,
          roomName: roomName,
          isUpcoming: false,
          content: question,
          pollId: poll.pollId,
        );
    if (!sent) {
      // The poll row exists; the announcement sits in chat as a failed
      // message with the usual tap-to-retry, so don't report failure here.
      log('poll announcement message failed for ${poll.pollId}');
    }
    return true;
  }

  /// Casts or changes this user's vote. Returns false if the vote could not
  /// be recorded.
  Future<bool> vote({required String pollId, required int optionIndex}) async {
    final current = state.value;
    if (current == null) return false;

    final poll = current.pollById(pollId);
    if (poll == null || poll.isClosed) return false;
    if (optionIndex < 0 || optionIndex >= poll.options.length) return false;

    final user = ref.read(requireUserProvider);
    final existing = current.voteByUser(pollId, user.uid);
    if (existing != null && existing.optionIndex == optionIndex) return true;

    // A write for this poll is still pending; racing it (e.g. updating a row
    // whose create hasn't landed) would 404, so drop the tap quietly.
    if (_votesInFlight.contains(pollId)) return true;
    _votesInFlight.add(pollId);
    try {
      if (existing == null) {
        return await _castVote(pollId, optionIndex, user.uid);
      }
      return await _changeVote(existing, optionIndex);
    } finally {
      _votesInFlight.remove(pollId);
    }
  }

  Future<bool> _castVote(String pollId, int optionIndex, String uid) async {
    final current = state.value;
    if (current == null) return false;

    final vote = PollVote(
      voteId: ID.unique(),
      pollId: pollId,
      roomId: roomId,
      uid: uid,
      optionIndex: optionIndex,
    );
    // Optimistic: count the vote immediately, roll back if the write fails.
    state = AsyncData(current.copyWith(votes: [...current.votes, vote]));
    try {
      await ref.read(roomPollsRepositoryProvider).castVote(vote);
      return true;
    } on AppwriteException catch (e) {
      if (!ref.mounted) return false;
      if (e.code == 409) {
        // The unique (pollId, uid) index rejected a duplicate — this user
        // already voted from another device/session. Drop the rejected
        // optimistic vote, then re-sync the truth (so it doesn't linger if
        // the reload fails too).
        _removeVote(vote.voteId);
        await _reconcileVotes(pollId);
        return false;
      }
      log('castVote failed: $e');
      _removeVote(vote.voteId);
      return false;
    } catch (e) {
      log('castVote failed: $e');
      if (!ref.mounted) return false;
      _removeVote(vote.voteId);
      return false;
    }
  }

  Future<bool> _changeVote(PollVote existing, int optionIndex) async {
    final updated = existing.copyWith(optionIndex: optionIndex);
    _replaceVote(updated);
    try {
      await ref.read(roomPollsRepositoryProvider).changeVote(updated);
      return true;
    } catch (e) {
      log('changeVote failed: $e');
      if (!ref.mounted) return false;
      _rollbackVote(optimistic: updated, previous: existing);
      return false;
    }
  }

  /// Host-only in the UI: closes voting and freezes the results.
  Future<bool> closePoll(String pollId) async {
    final current = state.value;
    if (current == null) return false;

    final idx = current.polls.indexWhere((p) => p.pollId == pollId);
    if (idx < 0) return false;
    final original = current.polls[idx];
    if (original.isClosed) return true;

    final closed = original.copyWith(isClosed: true);
    final polls = [...current.polls];
    polls[idx] = closed;
    state = AsyncData(current.copyWith(polls: polls));

    try {
      await ref.read(roomPollsRepositoryProvider).closePoll(pollId);
      return true;
    } catch (e) {
      log('closePoll failed: $e');
      if (!ref.mounted) return false;
      // Undo only our own optimistic object; if a realtime event replaced
      // it meanwhile, that data is newer than our snapshot.
      final rolled = state.value;
      if (rolled == null) return false;
      final i = rolled.polls.indexWhere((p) => p.pollId == pollId);
      if (i >= 0 && identical(rolled.polls[i], closed)) {
        final restored = [...rolled.polls];
        restored[i] = original;
        state = AsyncData(rolled.copyWith(polls: restored));
      }
      return false;
    }
  }

  Future<void> _reconcileVotes(String pollId) async {
    try {
      final fresh = await ref
          .read(roomPollsRepositoryProvider)
          .loadVotesForPoll(pollId);
      if (!ref.mounted) return;
      final current = state.value;
      if (current == null) return;
      state = AsyncData(
        current.copyWith(
          votes: [
            ...current.votes.where((v) => v.pollId != pollId),
            ...fresh,
          ],
        ),
      );
    } catch (e) {
      log('reconcileVotes failed: $e');
    }
  }

  void _removeVote(String voteId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        votes: current.votes.where((v) => v.voteId != voteId).toList(),
      ),
    );
  }

  void _replaceVote(PollVote vote) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        votes: [
          for (final v in current.votes)
            v.voteId == vote.voteId ? vote : v,
        ],
      ),
    );
  }

  /// Undoes an optimistic vote update, but only if our exact optimistic
  /// object is still in state — a realtime event that replaced it is newer
  /// than the [previous] snapshot and must not be clobbered.
  void _rollbackVote({required PollVote optimistic, required PollVote previous}) {
    final current = state.value;
    if (current == null) return;
    final idx = current.votes.indexWhere((v) => v.voteId == optimistic.voteId);
    if (idx < 0 || !identical(current.votes[idx], optimistic)) return;
    final votes = [...current.votes];
    votes[idx] = previous;
    state = AsyncData(current.copyWith(votes: votes));
  }
}
