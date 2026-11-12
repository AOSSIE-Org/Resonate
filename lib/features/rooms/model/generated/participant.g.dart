// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Participant _$ParticipantFromJson(Map<String, dynamic> json) => _Participant(
  uid: json['uid'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  dpUrl: json['dpUrl'] as String,
  isAdmin: json['isAdmin'] as bool,
  isMicOn: json['isMicOn'] as bool,
  isModerator: json['isModerator'] as bool,
  isSpeaker: json['isSpeaker'] as bool,
  hasRequestedToBeSpeaker: json['hasRequestedToBeSpeaker'] as bool,
);

Map<String, dynamic> _$ParticipantToJson(_Participant instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'dpUrl': instance.dpUrl,
      'isAdmin': instance.isAdmin,
      'isMicOn': instance.isMicOn,
      'isModerator': instance.isModerator,
      'isSpeaker': instance.isSpeaker,
      'hasRequestedToBeSpeaker': instance.hasRequestedToBeSpeaker,
    };
