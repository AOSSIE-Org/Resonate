import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/auth/viewmodel/email_verify_notifier.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/view/pages/friend_requests_page.dart';
import 'package:resonate/features/friends/view/pages/friends_page.dart';
import 'package:resonate/features/friends/viewmodel/friends_notifier.dart';
import 'package:resonate/features/profile/model/profile_view_data.dart';
import 'package:resonate/features/profile/viewmodel/profile_view_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/view/pages/story_page.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/features/profile/view/pages/followers_screen.dart';
import 'package:resonate/shared/widgets/loading_dialog.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final ResonateUser? creator;
  final bool? isCreatorProfile;

  ProfilePage({super.key, this.creator, this.isCreatorProfile})
      : assert(
          isCreatorProfile != true || (creator != null && creator.uid != null),
          'creator and creator.uid are required when isCreatorProfile is true',
        );

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool get _isCreator => widget.isCreatorProfile == true;
  String get _creatorId => widget.creator!.uid!;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authUser = ref.watch(authProvider).value?.userOrNull;
    final profileUserId = _isCreator ? _creatorId : authUser?.uid;
    final profileAsync = profileUserId != null
        ? ref.watch(profileViewProvider(profileUserId))
        : null;
    final profileData = profileAsync?.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: !_isCreator
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FriendRequestsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FriendsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.groups),
                ),
              ]
            : null,
      ),
      body: Builder(builder: (context) {
        final loading = (profileAsync?.isLoading ?? false) ||
            ref.watch(friendsProvider).isLoading;
        if (loading || authUser == null) {
          return Center(
            child: SizedBox(
              height: UiSizes.height_200,
              width: UiSizes.width_200,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotate,
                colors: [Theme.of(context).colorScheme.primary],
              ),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_10,
                  horizontal: UiSizes.width_20,
                ),
                width: double.maxFinite,
                child: Column(
                  children: [
                    _buildProfileHeader(context, authUser, profileData),
                    _buildEmailVerificationButton(context, authUser),
                    SizedBox(height: UiSizes.height_10),
                    _buildProfileButtons(context, authUser, profileData),
                  ],
                ),
              ),
              SizedBox(height: UiSizes.height_20),
              _buildStoriesSection(context, profileData),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    AuthUser authUser,
    ProfileViewData? profileData,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final followers = profileData?.followers ?? const [];

    return Row(
      children: [
        SizedBox(width: UiSizes.width_20),
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          backgroundImage: _isCreator
              ? NetworkImage(widget.creator!.profileImageUrl ?? '')
              : authUser.profileImageUrl == null ||
                      authUser.profileImageUrl!.isEmpty
                  ? NetworkImage(ref.watch(userProfileImagePlaceholderUrlProvider))
                  : NetworkImage(authUser.profileImageUrl!),
          radius: UiSizes.width_66,
        ),
        SizedBox(width: UiSizes.width_20),
        Expanded(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isCreator && authUser.isEmailVerified)
                  Padding(
                    padding: EdgeInsets.only(top: UiSizes.height_10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: Colors.green,
                        ),
                        SizedBox(width: UiSizes.width_5),
                        Text(
                          l10n.verified,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                Text(
                  _isCreator
                      ? widget.creator!.name ?? ''
                      : authUser.displayName,
                  style: TextStyle(
                    fontSize: UiSizes.size_24,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    "@${_isCreator ? widget.creator!.userName : authUser.userName}",
                    style: TextStyle(
                      fontSize: UiSizes.size_14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: UiSizes.width_5),
                      child: Text(
                        _isCreator
                            ? (widget.creator!.userRating ?? 0.0)
                                .toStringAsFixed(1)
                            : (authUser.ratingCount == 0
                                    ? 0.0
                                    : authUser.ratingTotal /
                                        authUser.ratingCount)
                                .toStringAsFixed(1),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    if (!(followers.length == 1 &&
                            (profileData?.isFollowing ?? false)) &&
                        _isCreator) {
                      final sanitizedFollowersList = followers
                          .where((follower) => follower.uid != authUser.uid)
                          .toList();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => FollowersScreen(
                            followers: sanitizedFollowersList,
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.people),
                      Padding(
                        padding: EdgeInsets.only(left: UiSizes.width_5),
                        child: Text(
                          _isCreator
                              ? followers.length.toString()
                              : authUser.followers.length.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: UiSizes.width_20),
      ],
    );
  }

  Widget _buildEmailVerificationButton(BuildContext context, AuthUser authUser) {
    final l10n = AppLocalizations.of(context)!;
    if (_isCreator || authUser.isEmailVerified) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: UiSizes.height_10),
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: () {
          loadingDialog(context);
          ref.read(emailVerifyProvider.notifier).sendOtp(email: authUser.email);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user_outlined),
            SizedBox(width: UiSizes.width_10),
            Text(l10n.verifyEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButtons(
    BuildContext context,
    AuthUser authUser,
    ProfileViewData? profileData,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isFollowing = profileData?.isFollowing ?? false;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_isCreator) {
                final notifier =
                    ref.read(profileViewProvider(_creatorId).notifier);
                if (isFollowing) {
                  notifier.unfollowCreator();
                } else {
                  notifier.followCreator(_creatorId);
                }
              } else {
                context.push(RoutePaths.editProfile);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFollowing ? colorScheme.secondary : colorScheme.primary,
              foregroundColor:
                  isFollowing ? colorScheme.onSecondary : colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: colorScheme.primary),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isCreator
                      ? (isFollowing ? Icons.done : Icons.add)
                      : Icons.edit,
                  color: colorScheme.onPrimary,
                ),
                SizedBox(width: UiSizes.width_8),
                Text(
                  _isCreator
                      ? (isFollowing ? l10n.following : l10n.follow)
                      : l10n.editProfile,
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: UiSizes.width_10),
        if (!_isCreator)
          // Square button kept literal: UiSizes width/height scale on different
          // axes, so a width_/height_ pair wouldn't stay square at runtime.
          SizedBox(
            height: 50,
            width: 50,
            child: ElevatedButton(
              onPressed: () => context.push(RoutePaths.settings),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: const CircleBorder(),
                padding: EdgeInsets.all(UiSizes.width_10),
              ),
              child: Icon(Icons.settings, color: colorScheme.onPrimary),
            ),
          )
        else
          Expanded(child: _buildFriendButton(context, colorScheme)),
      ],
    );
  }

  Widget _buildFriendButton(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    final friendsState = ref.watch(friendsProvider).value;
    final FriendsModel? friendModel =
        friendsState?.relationWith(widget.creator!.uid!);
    final friendsNotifier = ref.read(friendsProvider.notifier);

    return ElevatedButton(
      onPressed: () async {
        if (friendModel == null) {
          try {
            await friendsNotifier.sendFriendRequest(
              recieverId: widget.creator!.uid!,
              recieverProfileImageUrl: widget.creator!.profileImageUrl!,
              recieverUsername: widget.creator!.userName!,
              recieverName: widget.creator!.name!,
              recieverRating: widget.creator!.userRating ?? 0.0,
            );
          } catch (e) {
            log(e.toString());
            customSnackbar(l10n.error, e.toString(), LogType.error);
            return;
          }
          customSnackbar(
            l10n.friendRequestSent,
            l10n.friendRequestSentTo(widget.creator!.name!),
            LogType.success,
          );
        } else {
          if (friendModel.requestStatus == FriendRequestStatus.sent &&
              friendModel.senderId == widget.creator!.uid) {
            try {
              await friendsNotifier.acceptFriendRequest(friendModel);
            } catch (e) {
              log(e.toString());
              customSnackbar(l10n.error, e.toString(), LogType.error);
              return;
            }
            customSnackbar(
              l10n.friendRequestAccepted,
              l10n.friendRequestAcceptedTo(widget.creator!.name!),
              LogType.success,
            );
          } else {
            try {
              await friendsNotifier.removeFriend(friendModel);
            } catch (e) {
              log(e.toString());
            }
            customSnackbar(
              l10n.friendRequestCancelled,
              l10n.friendRequestCancelledTo(widget.creator!.name!),
              LogType.info,
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: friendModel != null
            ? (friendModel.requestStatus == FriendRequestStatus.sent
                ? colorScheme.primary
                : colorScheme.secondary)
            : colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: colorScheme.primary),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            friendModel != null
                ? (friendModel.requestStatus == FriendRequestStatus.sent
                    ? Icons.check
                    : Icons.people)
                : Icons.add,
            color: colorScheme.onPrimary,
          ),
          SizedBox(width: UiSizes.width_8),
          Text(
            friendModel != null
                ? (friendModel.requestStatus == FriendRequestStatus.sent
                    ? friendModel.senderId == widget.creator!.uid
                        ? l10n.accept
                        : l10n.requested
                    : l10n.friends)
                : l10n.addFriend,
            style: TextStyle(color: colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection(
    BuildContext context,
    ProfileViewData? profileData,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(left: UiSizes.width_20),
      width: double.maxFinite,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _isCreator ? l10n.userCreatedStories : l10n.yourStories,
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          _buildStoriesList(
            context,
            profileData?.createdStories ?? const [],
            _isCreator ? l10n.userNoStories : l10n.youNoStories,
          ),
          SizedBox(height: UiSizes.height_10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _isCreator ? l10n.userLikedStories : l10n.yourLikedStories,
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          _buildStoriesList(
            context,
            profileData?.likedStories ?? const [],
            _isCreator ? l10n.userNoLikedStories : l10n.youNoLikedStories,
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(
    BuildContext context,
    List<Story> stories,
    String noStoryTextToShow,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: UiSizes.height_200,
      child: stories.isNotEmpty
          ? ListView.builder(
              itemCount: stories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return StoryItem(story: stories[index]);
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Square image kept literal so it isn't distorted: UiSizes
                // width/height scale on different axes (won't stay 1:1).
                Image.asset(
                  height: 150,
                  width: 150,
                  AppImages.emptyBoxImage,
                ),
                SizedBox(height: UiSizes.height_5),
                Text(
                  noStoryTextToShow,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
    );
  }
}

class StoryItem extends StatelessWidget {
  const StoryItem({super.key, required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StoryPage(story: story)),
        );
      },
      child: Container(
        width: UiSizes.height_140,
        margin: EdgeInsets.only(right: UiSizes.width_10),
        child: Column(
          children: [
            Container(
              height: UiSizes.height_140,
              width: UiSizes.height_140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.surfaceContainerHighest,
                image: DecorationImage(
                  image: NetworkImage(story.coverImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: UiSizes.height_5),
            Text(
              story.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              story.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: UiSizes.size_12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
