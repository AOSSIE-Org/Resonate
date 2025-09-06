import 'package:freezed_annotation/freezed_annotation.dart';

enum FriendCallStatus {
  @JsonValue('waiting')
  waiting,
  @JsonValue('connected')
  connected,
  @JsonValue('declined')
  declined,
  @JsonValue('ended')
  ended,
}
