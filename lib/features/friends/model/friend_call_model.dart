import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

part 'generated/friend_call_model.freezed.dart';
part 'generated/friend_call_model.g.dart';

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
typedef CallSide = ({String uid, String name, String imageUrl});

extension FriendCallSides on FriendCallModel {
  ({CallSide local, CallSide remote}) sidesFor(String? myUid) {
    final caller = (
      uid: callerUid,
      name: callerName,
      imageUrl: callerProfileImageUrl,
    );
    final reciever = (
      uid: recieverUid,
      name: recieverName,
      imageUrl: recieverProfileImageUrl,
    );
    return myUid == recieverUid
        ? (local: reciever, remote: caller)
        : (local: caller, remote: reciever);
  }
}
