import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/rooms/model/poll.dart';
import 'package:resonate/features/rooms/model/poll_vote.dart';

part 'generated/room_polls_state.freezed.dart';

@freezed
abstract class RoomPollsState with _$RoomPollsState {
  const RoomPollsState._();

  const factory RoomPollsState({
    @Default(<Poll>[]) List<Poll> polls,
    @Default(<PollVote>[]) List<PollVote> votes,
  }) = _RoomPollsState;

  Poll? pollById(String pollId) {
    for (final poll in polls) {
      if (poll.pollId == pollId) return poll;
    }
    return null;
  }

  PollVote? voteByUser(String pollId, String uid) {
    for (final vote in votes) {
      if (vote.pollId == pollId && vote.uid == uid) return vote;
    }
    return null;
  }

  /// Vote tally per option index, ignoring votes that point outside the
  /// poll's options (e.g. after a malformed write).
  List<int> optionCountsFor(Poll poll) {
    final counts = List<int>.filled(poll.options.length, 0);
    for (final vote in votes) {
      if (vote.pollId == poll.pollId &&
          vote.optionIndex >= 0 &&
          vote.optionIndex < counts.length) {
        counts[vote.optionIndex]++;
      }
    }
    return counts;
  }
}
