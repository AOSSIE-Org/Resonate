// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../poll_vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PollVote _$PollVoteFromJson(Map<String, dynamic> json) => _PollVote(
  voteId: json[r'$id'] as String,
  pollId: json['pollId'] as String,
  roomId: json['roomId'] as String,
  uid: json['uid'] as String,
  optionIndex: (json['optionIndex'] as num).toInt(),
);

Map<String, dynamic> _$PollVoteToJson(_PollVote instance) => <String, dynamic>{
  r'$id': instance.voteId,
  'pollId': instance.pollId,
  'roomId': instance.roomId,
  'uid': instance.uid,
  'optionIndex': instance.optionIndex,
};
