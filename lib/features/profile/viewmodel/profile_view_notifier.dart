import 'package:appwrite/appwrite.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/profile_view_data.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/profile_view_notifier.g.dart';

@riverpod
class ProfileView extends _$ProfileView {
  @override
  Future<ProfileViewData> build(String creatorId) async {
    final repo = ref.watch(profileRepositoryProvider);

    final results = await Future.wait([
      repo.fetchCreatedStories(creatorId),
      repo.fetchLikedStories(creatorId),
      repo.fetchFollowers(creatorId),
    ]);

    final created = results[0] as List<Story>;
    final liked = results[1] as List<Story>;
    final followers = results[2] as List<FollowerUserModel>;

    final currentUid = ref.read(currentUserProvider)?.uid;
    FollowerUserModel? mine;
    for (final follower in followers) {
      if (follower.uid == currentUid) {
        mine = follower;
        break;
      }
    }

    return ProfileViewData(
      createdStories: created,
      likedStories: liked,
      followers: followers,
      isFollowing: mine != null,
      followerDocumentId: mine?.docId,
    );
  }

  Future<void> followCreator(String creatorId) async {
    final data = state.value;
    final user = ref.read(currentUserProvider);
    if (data == null || user == null) return;

    final repo = ref.read(profileRepositoryProvider);
    final fcmToken = await repo.getFcmToken();

    final follower = FollowerUserModel(
      docId: ID.unique(),
      uid: user.uid,
      username: user.userName ?? '',
      profileImageUrl: user.profileImageUrl ?? '',
      name: user.displayName,
      fcmToken: fcmToken ?? '',
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
