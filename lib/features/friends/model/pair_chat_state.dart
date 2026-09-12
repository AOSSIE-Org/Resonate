import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/shared/model/resonate_user.dart';

part 'generated/pair_chat_state.freezed.dart';

@freezed
abstract class PairChatState with _$PairChatState {
  const factory PairChatState({
    @Default(true) bool isAnonymous,
    @Default('en') String languageIso,
    @Default(false) bool isMicOn,
    @Default(true) bool isLoudSpeakerOn,
    String? requestDocId,
    String? activePairDocId,
    String? pairUsername,
    String? pairProfileImageUrl,
    @Default(2.5) double pairRating,
    @Default(<ResonateUser>[]) List<ResonateUser> onlineUsers,
    @Default(false) bool isUserListLoading,
    // showing the rating sheet and returning to the tab view.
    @Default(false) bool ended,
  }) = _PairChatState;
}
