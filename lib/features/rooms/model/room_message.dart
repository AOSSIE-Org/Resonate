import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';

part 'generated/room_message.freezed.dart';
part 'generated/room_message.g.dart';

// Client-only send state for chat messages. Not persisted server-side.
enum RoomMessageStatus { pending, sent, failed }

@freezed
abstract class RoomMessage with _$RoomMessage {
  const RoomMessage._();

  const factory RoomMessage({
    required String roomId,
    required String messageId,
    required String creatorId,
    required String creatorUsername,
    required String creatorName,
    required String creatorImgUrl,
    required bool hasValidTag,
    required int index,
    required bool isEdited,
    required String content,
    required DateTime creationDateTime,
    @Default(false) bool isDeleted,
    ReplyTo? replyTo,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(RoomMessageStatus.sent)
    RoomMessageStatus status,
  }) = _RoomMessage;

  factory RoomMessage.fromJson(Map<String, dynamic> json) => _$RoomMessageFromJson({
    ...json,
    'isDeleted': json['isDeleted'] ?? false,
  });

  Map<String, dynamic> toJsonForUpload() {
    final json = toJson();
    json.remove('replyTo');
    json['creationDateTime'] = creationDateTime.toUtc().toIso8601String();
    return json;
  }
}
