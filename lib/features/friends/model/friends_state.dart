import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:resonate/features/friends/model/friends_model.dart';

part 'generated/friends_state.freezed.dart';

@freezed
abstract class FriendsState with _$FriendsState {
  const FriendsState._();

  const factory FriendsState({
    @Default(<FriendsModel>[]) List<FriendsModel> friends,
    @Default(<FriendsModel>[]) List<FriendsModel> friendRequests,
  }) = _FriendsState;

  FriendsModel? relationWith(String uid) {
    for (final friend in [...friends, ...friendRequests]) {
      if (friend.senderId == uid || friend.recieverId == uid) return friend;
    }
    return null;
  }
}

@freezed
sealed class FriendsFailure with _$FriendsFailure {
  const factory FriendsFailure.notFound() = FriendsFailureNotFound;
  const factory FriendsFailure.network() = FriendsFailureNetwork;
  const factory FriendsFailure.permissionDenied() = FriendsFailurePermissionDenied;
  const factory FriendsFailure.unknown(String message) = FriendsFailureUnknown;
}
