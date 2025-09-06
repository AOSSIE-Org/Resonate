import 'package:freezed_annotation/freezed_annotation.dart';

enum FriendRequestStatus {
  @JsonValue('sent')
  sent,
  @JsonValue('accepted')
  accepted,
}
