import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/poll.freezed.dart';
part 'generated/poll.g.dart';

@freezed
abstract class Poll with _$Poll {
  const Poll._();

  const factory Poll({
    // Did this because the poll has no dedicated id attribute server-side —
    // the Appwrite row id ($id) doubles as the poll id. Could refactor to a
    // separate pollId attribute like chat's messageId if that's preferred.
    @JsonKey(name: r'$id') required String pollId,
    required String roomId,
    required String question,
    @Default(<String>[]) List<String> options,
    required String createdBy,
    @Default(false) bool isClosed,
  }) = _Poll;

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson({
    ...json,
    'options': json['options'] ?? const <String>[],
    'isClosed': json['isClosed'] ?? false,
  });

  Map<String, dynamic> toJsonForUpload() {
    final json = toJson();
    json.remove(r'$id');
    return json;
  }
}
