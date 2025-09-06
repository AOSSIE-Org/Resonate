import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

part 'friend_call_model.freezed.dart';
part 'friend_call_model.g.dart';

@freezed
abstract class FriendCallModel with _$FriendCallModel {
  factory FriendCallModel({
    required final String callerName,
    required final String recieverName,
    required final String callerUsername,
    required final String recieverUsername,
    required final String callerUid,
    required final String recieverUid,
    required final String callerProfileImageUrl,
    required final String recieverProfileImageUrl,
    required final String livekitRoomId,
    required final FriendCallStatus callStatus,
    @JsonKey(name: "\$id", includeToJson: false) required final String docId,
  }) = _FriendCallModel;

  factory FriendCallModel.fromJson(Map<String, dynamic> json) =>
      _$FriendCallModelFromJson(json);
}
