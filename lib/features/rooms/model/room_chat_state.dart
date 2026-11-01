import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/rooms/model/reply_to.dart';
import 'package:resonate/features/rooms/model/room_message.dart';

part 'generated/room_chat_state.freezed.dart';

@freezed
abstract class RoomChatState with _$RoomChatState {
  const factory RoomChatState({
    @Default(<RoomMessage>[]) List<RoomMessage> messages,
    ReplyTo? replyingTo,
  }) = _RoomChatState;
}
