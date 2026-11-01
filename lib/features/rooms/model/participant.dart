import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/participant.freezed.dart';
part 'generated/participant.g.dart';

const _defaultAvatar =
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80';

@freezed
abstract class Participant with _$Participant {
  const factory Participant({
    required String uid,
    required String email,
    required String name,
    required String dpUrl,
    required bool isAdmin,
    required bool isMicOn,
    required bool isModerator,
    required bool isSpeaker,
    required bool hasRequestedToBeSpeaker,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson({
        ...json,
        'name': json['name'] ?? 'Unknown',
        'dpUrl': json['dpUrl'] ?? _defaultAvatar,
      });
}
