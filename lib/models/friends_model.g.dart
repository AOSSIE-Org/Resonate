// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendsModel _$FriendsModelFromJson(Map<String, dynamic> json) =>
    _FriendsModel(
      senderId: json['senderId'] as String,
      recieverId: json['recieverId'] as String,
      senderProfileImgUrl: json['senderProfileImgUrl'] as String,
      recieverProfileImgUrl: json['recieverProfileImgUrl'] as String,
      senderUsername: json['senderUsername'] as String,
      recieverUsername: json['recieverUsername'] as String,
      senderName: json['senderName'] as String,
      recieverName: json['recieverName'] as String,
      senderFCMToken: json['senderFCMToken'] as String?,
      recieverFCMToken: json['recieverFCMToken'] as String?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requestStatus: $enumDecode(
        _$FriendRequestStatusEnumMap,
        json['requestStatus'],
      ),
      requestSentByUserId: json['requestSentByUserId'] as String,
      senderRating: toDouble(json['senderRating']),
      recieverRating: toDouble(json['recieverRating']),
      docId: json[r'$id'] as String,
    );

Map<String, dynamic> _$FriendsModelToJson(_FriendsModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'recieverId': instance.recieverId,
      'senderProfileImgUrl': instance.senderProfileImgUrl,
      'recieverProfileImgUrl': instance.recieverProfileImgUrl,
      'senderUsername': instance.senderUsername,
      'recieverUsername': instance.recieverUsername,
      'senderName': instance.senderName,
      'recieverName': instance.recieverName,
      'senderFCMToken': instance.senderFCMToken,
      'recieverFCMToken': instance.recieverFCMToken,
      'users': instance.users,
      'requestStatus': _$FriendRequestStatusEnumMap[instance.requestStatus]!,
      'requestSentByUserId': instance.requestSentByUserId,
      'senderRating': instance.senderRating,
      'recieverRating': instance.recieverRating,
    };

const _$FriendRequestStatusEnumMap = {
  FriendRequestStatus.sent: 'sent',
  FriendRequestStatus.accepted: 'accepted',
};
