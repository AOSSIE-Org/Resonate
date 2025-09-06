import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

part 'friends_model.freezed.dart';
part 'friends_model.g.dart';

@freezed
abstract class FriendsModel with _$FriendsModel {
  const FriendsModel._();
  factory FriendsModel({
    required String senderId,
    required String recieverId,
    required String senderProfileImgUrl,
    required String recieverProfileImgUrl,
    required String senderUsername,
    required String recieverUsername,
    required String senderName,
    required String recieverName,
    String? senderFCMToken,
    String? recieverFCMToken,
    List<String>? users,
    required FriendRequestStatus requestStatus,
    required String requestSentByUserId,
    @JsonKey(fromJson: toDouble) required double? senderRating,
    @JsonKey(fromJson: toDouble) required double? recieverRating,
    @JsonKey(name: "\$id", includeToJson: false) required String docId,
  }) = _FriendsModel;

  factory FriendsModel.fromJson(Map<String, dynamic> json) =>
      _$FriendsModelFromJson(json);

  ResonateUser recieverToResonateUserForRequestsPage() {
    return ResonateUser(
      uid: recieverId,
      userName: recieverName,
      profileImageUrl: recieverProfileImgUrl,
      name: recieverName,
      docId: docId,

      userRating: recieverRating!,
      // Note: email, dateOfBirth are not available in FollowerUserModel
      // so they will be null in the converted ResonateUser
      email: null,
      dateOfBirth: null,
    );
  }

  ResonateUser senderToResonateUserForRequestsPage() {
    return ResonateUser(
      uid: senderId,
      userName: senderName,
      profileImageUrl: senderProfileImgUrl,
      name: senderName,
      docId: docId,

      userRating: senderRating!,
      // Note: email, dateOfBirth are not available in FollowerUserModel
      // so they will be null in the converted ResonateUser
      email: null,
      dateOfBirth: null,
    );
  }
}
