import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/models/story.dart';

class ProfileViewData {
  const ProfileViewData({
    this.createdStories = const <Story>[],
    this.likedStories = const <Story>[],
    this.followers = const <FollowerUserModel>[],
    this.isFollowing = false,
    this.followerDocumentId,
  });

  final List<Story> createdStories;
  final List<Story> likedStories;
  final List<FollowerUserModel> followers;

  final bool isFollowing;
  final String? followerDocumentId;

  ProfileViewData copyWith({
    List<Story>? createdStories,
    List<Story>? likedStories,
    List<FollowerUserModel>? followers,
    bool? isFollowing,
    String? followerDocumentId,
    bool clearFollowerDocumentId = false,
  }) =>
      ProfileViewData(
        createdStories: createdStories ?? this.createdStories,
        likedStories: likedStories ?? this.likedStories,
        followers: followers ?? this.followers,
        isFollowing: isFollowing ?? this.isFollowing,
        followerDocumentId: clearFollowerDocumentId
            ? null
            : (followerDocumentId ?? this.followerDocumentId),
      );
}
