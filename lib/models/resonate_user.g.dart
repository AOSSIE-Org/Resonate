// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resonate_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ResonateUser _$$_ResonateUserFromJson(Map<String, dynamic> json) =>
    _$_ResonateUser(
      uid: json['uid'] as String?,
      userName: json['userName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
    );

Map<String, dynamic> _$$_ResonateUserToJson(_$_ResonateUser instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'profileImageUrl': instance.profileImageUrl,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
    };
