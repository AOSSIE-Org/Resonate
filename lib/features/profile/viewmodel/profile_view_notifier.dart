import 'dart:async';

import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/profile_view_data.dart';
import 'package:resonate/shared/model/follower_user_model.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/profile_view_notifier.g.dart';

@riverpod
class ProfileView extends _$ProfileView {
  StreamSubscription<void>? _followersSub;

  @override
  Future<ProfileViewData> build(String creatorId) async {
    ref.onDispose(_cancelSub);
    final repo = ref.watch(profileRepositoryProvider);
    final stories = ref.watch(storiesRepositoryProvider);
    final currentUid = ref.read(currentUserProvider)?.uid;

    final results = await Future.wait([
      stories.fetchCreatedStories(creatorId, viewerUid: currentUid),
      stories.fetchLikedStories(creatorId, viewerUid: currentUid),
      repo.fetchFollowers(creatorId),
    ]);

    final created = results[0] as List<Story>;
    final liked = results[1] as List<Story>;
    final followers = results[2] as List<FollowerUserModel>;

    FollowerUserModel? mine;
    for (final follower in followers) {
      if (follower.uid == currentUid) {
        mine = follower;
        break;
      }
    }
    await _cancelSub();
    _followersSub = repo
        .followersChanged(creatorId)
        .listen((_) => unawaited(_refreshFollowers(creatorId)));

    return ProfileViewData(
      createdStories: created,
      likedStories: liked,
      followers: followers,
      isFollowing: mine != null,
      followerDocumentId: mine?.docId,
    );
  }

  Future<void> _refreshFollowers(String creatorId) async {
    final data = state.value;
    if (data == null) return;
    final followers = await ref
        .read(profileRepositoryProvider)
        .fetchFollowers(creatorId);
    if (!ref.mounted) return;
    final currentUid = ref.read(currentUserProvider)?.uid;
    FollowerUserModel? mine;
    for (final follower in followers) {
      if (follower.uid == currentUid) {
        mine = follower;
        break;
      }
    }
    state = AsyncData(
      data.copyWith(
        followers: followers,
        isFollowing: mine != null,
        followerDocumentId: mine?.docId,
      ),
    );
  }

  // Nulls the field before the async cancel, so a rebuild cannot cancel twice.
  Future<void> _cancelSub() async {
    final sub = _followersSub;
    _followersSub = null;
    await sub?.cancel();
  }

  Future<void> followCreator(String creatorId) async {
    final data = state.value;
    final user = ref.read(currentUserProvider);
    if (data == null || user == null) return;

    final repo = ref.read(profileRepositoryProvider);
    final follower = FollowerUserModel(
      docId: repo.newFollowerDocumentId(),
      uid: user.uid,
      username: user.userName ?? '',
      profileImageUrl: user.profileImageUrl ?? '',
      name: user.displayName,
      followingUserId: creatorId,
      followerRating:
          user.ratingCount == 0 ? 0 : user.ratingTotal / user.ratingCount,
    );

    await repo.followCreator(follower);
    if (!ref.mounted) return;

    state = AsyncData(
      data.copyWith(
        followers: [...data.followers, follower],
        isFollowing: true,
        followerDocumentId: follower.docId,
      ),
    );
  }

  Future<void> unfollowCreator() async {
    final data = state.value;
    final docId = data?.followerDocumentId;
    if (data == null || docId == null) return;

    await ref.read(profileRepositoryProvider).unfollowCreator(docId);
    if (!ref.mounted) return;

    state = AsyncData(
      data.copyWith(
        followers:
            data.followers.where((f) => f.docId != docId).toList(),
        isFollowing: false,
        clearFollowerDocumentId: true,
      ),
    );
  }
}
