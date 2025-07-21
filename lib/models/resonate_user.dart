import 'package:freezed_annotation/freezed_annotation.dart';

part 'resonate_user.freezed.dart';
part 'resonate_user.g.dart';

@freezed
abstract class ResonateUser with _$ResonateUser {
  const factory ResonateUser({
    String? uid,
    @JsonKey(name: 'userName') String? userName,
    String? profileImageUrl,
    String? name,
    String? email,
    @JsonKey(name: 'dob') String? dateOfBirth,
    String? docId,
  }) = _ResonateUser;

  factory ResonateUser.fromJson(Map<String, dynamic> json) =>
      _$ResonateUserFromJson(json);
}
