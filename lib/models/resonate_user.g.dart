// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resonate_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResonateUser _$ResonateUserFromJson(Map<String, dynamic> json) =>
    _ResonateUser(
      uid: json['uid'] as String?,
      userName: json['userName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['dob'] as String?,
      docId: json['docId'] as String?,
      userRating: (json['userRating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ResonateUserToJson(_ResonateUser instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'profileImageUrl': instance.profileImageUrl,
      'name': instance.name,
      'email': instance.email,
      'dob': instance.dateOfBirth,
      'docId': instance.docId,
      'userRating': instance.userRating,
    };
