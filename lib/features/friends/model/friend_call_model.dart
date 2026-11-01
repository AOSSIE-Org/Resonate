import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

part 'generated/friend_call_model.freezed.dart';
part 'generated/friend_call_model.g.dart';

@freezed
abstract class FriendCallModel with _$FriendCallModel {
  factory FriendCallModel({
    required String callerName,
    required String recieverName,
    required String callerUsername,
    required String recieverUsername,
    required String callerUid,
    required String recieverUid,
    required String callerProfileImageUrl,
    required String recieverProfileImageUrl,
    required String livekitRoomId,
    required FriendCallStatus callStatus,
    @JsonKey(name: "\$id", includeToJson: false) required String docId,
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
