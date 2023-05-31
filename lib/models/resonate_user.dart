import 'package:freezed_annotation/freezed_annotation.dart';

part 'resonate_user.freezed.dart';
part 'resonate_user.g.dart';

@freezed
class ResonateUser with _$ResonateUser {
  const factory ResonateUser({
    String? uid,
    String? userName,
    String? profileImageUrl,
    String? gender,
    String? dateOfBirth,
  }) = _ResonateUser;

  factory ResonateUser.fromJson(Map<String, dynamic> json) =>
      _$ResonateUserFromJson(json);
}
