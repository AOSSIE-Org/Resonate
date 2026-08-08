import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/poll_vote.freezed.dart';
part 'generated/poll_vote.g.dart';

@freezed
abstract class PollVote with _$PollVote {
  const PollVote._();

  const factory PollVote({
    // Row id doubles as the vote id, mirroring Poll. A unique (pollId, uid)
    // index server-side rejects duplicate votes with a 409.
    @JsonKey(name: r'$id') required String voteId,
    required String pollId,
    required String roomId,
    required String uid,
    required int optionIndex,
  }) = _PollVote;

  factory PollVote.fromJson(Map<String, dynamic> json) =>
      _$PollVoteFromJson(json);

  Map<String, dynamic> toJsonForUpload() {
    final json = toJson();
    json.remove(r'$id');
    return json;
  }
}
