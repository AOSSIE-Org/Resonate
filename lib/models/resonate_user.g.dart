// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resonate_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResonateUserImpl _$$ResonateUserImplFromJson(Map<String, dynamic> json) =>
    _$ResonateUserImpl(
      uid: json['uid'] as String?,
      userName: json['userName'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
    );

Map<String, dynamic> _$$ResonateUserImplToJson(_$ResonateUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'profileImageUrl': instance.profileImageUrl,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
    };
