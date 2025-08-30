import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/models/resonate_user.dart';

part 'follower_user_model.freezed.dart';
part 'follower_user_model.g.dart';

@freezed
abstract class FollowerUserModel with _$FollowerUserModel {
  const FollowerUserModel._();

  factory FollowerUserModel({
    @JsonKey(name: "\$id", includeToJson: false) required String docId,
    @JsonKey(name: "followerUserId") required String uid,
    @JsonKey(name: "followerUsername") required String username,
    @JsonKey(name: "followerProfileImageUrl") required String profileImageUrl,
    @JsonKey(name: "followerName") required String name,
    @JsonKey(name: 'followerFCMToken') required String fcmToken,
    @JsonKey(name: "followingUserId") String? followingUserId,
    @JsonKey(name: 'followerRating') required double followerRating,
  }) = _FollowerUserModel;

  factory FollowerUserModel.fromJson(Map<String, dynamic> json) =>
      _$FollowerUserModelFromJson(json);

  /// Converts this FollowerUserModel to a ResonateUser
  ResonateUser toResonateUser() {
    return ResonateUser(
      uid: uid,
      userName: username,
      profileImageUrl: profileImageUrl,
      name: name,
      docId: uid,

      userRating: followerRating,
      // Note: email, dateOfBirth are not available in FollowerUserModel
      // so they will be null in the converted ResonateUser
      email: null,
      dateOfBirth: null,
    );
  }
}
