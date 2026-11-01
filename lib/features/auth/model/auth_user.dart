import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/models/follower_user_model.dart';

part 'generated/auth_user.freezed.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String email,
    required String displayName,
    required bool isEmailVerified,
    required bool isProfileComplete,
    String? userName,
    String? profileImageUrl,
    String? profileImageID,
    @Default(5.0) double ratingTotal,
    @Default(1) int ratingCount,
    @Default(<FollowerUserModel>[]) List<FollowerUserModel> followers,
    @Default(0) int reportsCount,
  }) = _AuthUser;
}
