import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/resonate_user.freezed.dart';
part 'generated/resonate_user.g.dart';

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
    @JsonKey(fromJson: toDouble) double? userRating,
    @Default(<String>[]) List<String> interests,
  }) = _ResonateUser;

  factory ResonateUser.fromJson(Map<String, dynamic> json) =>
      _$ResonateUserFromJson(json);

  static ResonateUser fromRow(Map<String, dynamic> data, String id) {
    final userData = Map<String, dynamic>.from(data);
    userData['docId'] = id;
    userData['uid'] = id;
    userData['userName'] = userData['username'];
    final ratingCount = (userData['ratingCount'] ?? 0) as num;
    userData['userRating'] = ratingCount == 0
        ? 0
        : userData['ratingTotal'] / ratingCount;
    return ResonateUser.fromJson(userData);
  }
}

double? toDouble(dynamic value) {
  if (value == null) return null;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return null;
}
