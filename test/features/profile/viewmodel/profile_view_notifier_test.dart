import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/viewmodel/profile_view_notifier.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/shared/model/follower_user_model.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../../../helpers/test_root_container.dart';
import '../fake_profile_repository.dart';

Story _story(String id) => Story(
      title: 'Story $id',
      storyId: id,
      description: 'desc',
      userIsCreator: false,
      category: StoryCategory.comedy,
      coverImageUrl: 'http://cover/$id',
      creatorId: 'creator1',
      creatorName: 'Creator',
      creatorImgUrl: 'http://img',
      creationDate: DateTime(2024),
      likesCount: 0,
      isLikedByCurrentUser: false,
      playDuration: 60,
      tintColor: const Color(0xff0000FF),
    );

FollowerUserModel _follower({required String uid, required String docId}) =>
    FollowerUserModel(
      docId: docId,
      uid: uid,
      username: '$uid-name',
      profileImageUrl: 'http://img/$uid',
      name: 'Name $uid',
      fcmToken: 'tok-$uid',
      followingUserId: 'creator1',
      followerRating: 5,
    );

Future<ProviderContainer> _buildContainer(
  FakeProfileRepository repo,
) async {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(
          AuthState.authenticated(
            fakeAuthUser(
              uid: 'me',
              userName: 'meuser',
              profileImageUrl: 'http://img/me',
              displayName: 'Me',
              ratingTotal: 10,
              ratingCount: 2,
            ),
          ),
        ),
      ),
      profileRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authSessionProvider.future);
  return container;
}

void main() {
  group('ProfileView.build', () {
    test('composes stories + followers and detects not-following', () async {
      final repo = FakeProfileRepository()
        ..createdStories = [_story('s1')]
        ..likedStories = [_story('s2')]
        ..followers = [_follower(uid: 'other', docId: 'f-other')];
      final container = await _buildContainer(repo);

      final data = await container.read(profileViewProvider('creator1').future);

      expect(data.createdStories.length, 1);
      expect(data.likedStories.length, 1);
      expect(data.followers.length, 1);
      expect(data.isFollowing, false);
      expect(data.followerDocumentId, isNull);
    });

    test('detects following when current user is in the followers list',
        () async {
      final repo = FakeProfileRepository()
        ..followers = [_follower(uid: 'me', docId: 'my-follow-doc')];
      final container = await _buildContainer(repo);

      final data = await container.read(profileViewProvider('creator1').future);

      expect(data.isFollowing, true);
      expect(data.followerDocumentId, 'my-follow-doc');
    });
  });

  group('ProfileView.followCreator', () {
    test('builds the follower from the current user and updates state',
        () async {
      final repo = FakeProfileRepository()..fcmToken = 'my-token';
      final container = await _buildContainer(repo);
      await container.read(profileViewProvider('creator1').future);

      await container
          .read(profileViewProvider('creator1').notifier)
          .followCreator('creator1');

      final follower = repo.followedFollower;
      expect(follower, isNotNull);
      expect(follower!.uid, 'me');
      expect(follower.username, 'meuser');
      expect(follower.profileImageUrl, 'http://img/me');
      expect(follower.name, 'Me');
      expect(follower.fcmToken, 'my-token');
      expect(follower.followingUserId, 'creator1');
      expect(follower.followerRating, 5); // 10 / 2

      final data = container.read(profileViewProvider('creator1')).value!;
      expect(data.isFollowing, true);
      expect(data.followers.length, 1);
      expect(data.followerDocumentId, follower.docId);
    });
  });

  group('ProfileView.unfollowCreator', () {
    test('removes the current user and clears the follow doc id', () async {
      final repo = FakeProfileRepository()
        ..followers = [_follower(uid: 'me', docId: 'my-follow-doc')];
      final container = await _buildContainer(repo);
      await container.read(profileViewProvider('creator1').future);

      await container
          .read(profileViewProvider('creator1').notifier)
          .unfollowCreator();

      expect(repo.unfollowedDocId, 'my-follow-doc');
      final data = container.read(profileViewProvider('creator1')).value!;
      expect(data.isFollowing, false);
      expect(data.followers, isEmpty);
      expect(data.followerDocumentId, isNull);
    });
  });
}
