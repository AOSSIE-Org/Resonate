// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FollowerUserModel _$FollowerUserModelFromJson(Map<String, dynamic> json) =>
    _FollowerUserModel(
      docId: json[r'$id'] as String,
      uid: json['followerUserId'] as String,
      username: json['followerUsername'] as String,
      profileImageUrl: json['followerProfileImageUrl'] as String,
      name: json['followerName'] as String,
      fcmToken: json['followerFCMToken'] as String,
      followingUserId: json['followingUserId'] as String?,
      followerRating: (json['followerRating'] as num).toDouble(),
    );

Map<String, dynamic> _$FollowerUserModelToJson(_FollowerUserModel instance) =>
    <String, dynamic>{
      'followerUserId': instance.uid,
      'followerUsername': instance.username,
      'followerProfileImageUrl': instance.profileImageUrl,
      'followerName': instance.name,
      'followerFCMToken': instance.fcmToken,
      'followingUserId': instance.followingUserId,
      'followerRating': instance.followerRating,
    };
