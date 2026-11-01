import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';

part 'generated/friend_call_state.freezed.dart';

@freezed
abstract class FriendCallState with _$FriendCallState {
  const factory FriendCallState({
    FriendCallModel? activeCall,
    @Default(false) bool isMicOn,
    @Default(true) bool isLoudSpeakerOn,
  }) = _FriendCallState;
}
