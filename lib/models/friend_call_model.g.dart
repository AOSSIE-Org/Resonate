// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_call_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendCallModel _$FriendCallModelFromJson(Map<String, dynamic> json) =>
    _FriendCallModel(
      callerName: json['callerName'] as String,
      recieverName: json['recieverName'] as String,
      callerUsername: json['callerUsername'] as String,
      recieverUsername: json['recieverUsername'] as String,
      callerUid: json['callerUid'] as String,
      recieverUid: json['recieverUid'] as String,
      callerProfileImageUrl: json['callerProfileImageUrl'] as String,
      recieverProfileImageUrl: json['recieverProfileImageUrl'] as String,
      livekitRoomId: json['livekitRoomId'] as String,
      callStatus: $enumDecode(_$FriendCallStatusEnumMap, json['callStatus']),
      docId: json[r'$id'] as String,
    );

Map<String, dynamic> _$FriendCallModelToJson(_FriendCallModel instance) =>
    <String, dynamic>{
      'callerName': instance.callerName,
      'recieverName': instance.recieverName,
      'callerUsername': instance.callerUsername,
      'recieverUsername': instance.recieverUsername,
      'callerUid': instance.callerUid,
      'recieverUid': instance.recieverUid,
      'callerProfileImageUrl': instance.callerProfileImageUrl,
      'recieverProfileImageUrl': instance.recieverProfileImageUrl,
      'livekitRoomId': instance.livekitRoomId,
      'callStatus': _$FriendCallStatusEnumMap[instance.callStatus]!,
    };

const _$FriendCallStatusEnumMap = {
  FriendCallStatus.waiting: 'waiting',
  FriendCallStatus.connected: 'connected',
  FriendCallStatus.declined: 'declined',
  FriendCallStatus.ended: 'ended',
};
