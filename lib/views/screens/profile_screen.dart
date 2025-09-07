import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/controllers/user_profile_controller.dart';
import 'package:resonate/models/friends_model.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/screens/followers_screen.dart';
import 'package:resonate/views/screens/friend_requests_screen.dart';
import 'package:resonate/views/screens/friends_screen.dart';
import 'package:resonate/views/screens/story_screen.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';
import 'package:resonate/views/widgets/snackbar.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_images.dart';
import '../../utils/ui_sizes.dart';
import 'package:resonate/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final ResonateUser? creator;

  final bool? isCreatorProfile;

  ProfileScreen({super.key, this.creator, this.isCreatorProfile})
    : assert(
        isCreatorProfile != true || (creator != null && creator.uid != null),
        'creator and creator.uid are required when isCreatorProfile is true',
      );

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isCreatorProfile == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await userProfileController.initializeProfile(widget.creator!.uid!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<UserProfileController>();
  }

  final emailVerifyController = Get.put<EmailVerifyController>(
    EmailVerifyController(),
  );

  final themeController = Get.find<ThemeController>();

  final authController = Get.find<AuthStateController>();

  final userProfileController = Get.put(UserProfileController());
  final exploreStoryController = Get.find<ExploreStoryController>();
  final friendsController = Get.find<FriendsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: widget.isCreatorProfile == null
            ? [
                IconButton(
                  onPressed: () {
                    Get.to(() => FriendRequestsScreen());
                  },
                  icon: Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => FriendsScreen());
                  },
                  icon: Icon(Icons.groups),
                ),
              ]
            : null,
      ),
      body: Obx(
        () =>
            userProfileController.isLoadingProfilePage.value ||
                friendsController.isLoadingFriends.value
            ? Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotate,
                    colors: [Theme.of(context).colorScheme.primary],
                  ),
                ),
              )
            : SingleChildScrollView(
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
                          _buildProfileHeader(context),
                          _buildEmailVerificationButton(
                            context,
                            emailVerifyController,
                            authController,
                          ),
                          SizedBox(height: UiSizes.height_10),
                          _buildProfileButtons(context),
                        ],
                      ),
                    ),
                    SizedBox(height: UiSizes.height_20),
                    _buildStoriesSection(context),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GetBuilder<AuthStateController>(
      builder: (controller) => Row(
        children: [
          SizedBox(width: UiSizes.width_20),
          CircleAvatar(
            backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
            backgroundImage: widget.isCreatorProfile != null
                ? NetworkImage(widget.creator!.profileImageUrl ?? '')
                : controller.profileImageUrl == null ||
                      controller.profileImageUrl!.isEmpty
                ? NetworkImage(themeController.userProfileImagePlaceholderUrl)
                : NetworkImage(controller.profileImageUrl ?? ''),
            radius: UiSizes.width_66,
          ),
          SizedBox(width: UiSizes.width_20),
          Expanded(
            child: MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isCreatorProfile == null &&
                      controller.isEmailVerified!)
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: Colors.green,
                          ),
                          SizedBox(width: 5),
                          Text(
                            AppLocalizations.of(context)!.verified,
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    widget.isCreatorProfile != null
                        ? widget.creator!.name ?? ''
                        : controller.displayName.toString(),
                    style: TextStyle(
                      fontSize: UiSizes.size_24,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    label: Text(
                      "@${widget.isCreatorProfile != null ? widget.creator!.userName : controller.userName}",
                      style: TextStyle(
                        fontSize: UiSizes.size_14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          widget.isCreatorProfile == null
                              ? (authController.ratingTotal /
                                        authController.ratingCount)
                                    .toStringAsFixed(1)
                              : widget.creator!.userRating!.toStringAsFixed(1),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      //If current user is only follower or signed in user profile is being viewed then don't route
                      if (!(userProfileController
                                      .searchedUserFollowers
                                      .length ==
                                  1 &&
                              userProfileController.isFollowingUser.value) &&
                          widget.isCreatorProfile != null) {
                        //Remove current user from followers list
                        final sanitizedFollowersList = userProfileController
                            .searchedUserFollowers
                            .where((follower) {
                              return follower.uid != authController.uid;
                            })
                            .toList();
                        Get.to(
                          FollowersScreen(followers: sanitizedFollowersList),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.people),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: widget.isCreatorProfile == null
                              ? Text(
                                  authController.followerDocuments.length
                                      .toString(),
                                )
                              : Obx(
                                  () => Text(
                                    userProfileController
                                        .searchedUserFollowers
                                        .length
                                        .toString(),
                                  ),
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
      ),
    );
  }

  Widget _buildEmailVerificationButton(
    BuildContext context,
    EmailVerifyController emailVerifyController,
    AuthStateController controller,
  ) {
    if (widget.isCreatorProfile != null || controller.isEmailVerified!) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: UiSizes.height_10),
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: () {
          loadingDialog(context);
          emailVerifyController.isSending.value = true;
          emailVerifyController.sendOTP();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_outlined),
            SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.verifyEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Obx(() {
            return ElevatedButton(
              onPressed: () {
                if (widget.isCreatorProfile != null) {
                  if (userProfileController.isFollowingUser.value) {
                    userProfileController.unfollowCreator();
                  } else {
                    userProfileController.followCreator(widget.creator!.uid!);
                  }
                } else {
                  Get.toNamed(AppRoutes.editProfile);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: userProfileController.isFollowingUser.value
                    ? colorScheme.secondary
                    : colorScheme.primary,
                foregroundColor: userProfileController.isFollowingUser.value
                    ? colorScheme.onSecondary
                    : colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: colorScheme.primary),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isCreatorProfile != null
                        ? userProfileController.isFollowingUser.value
                              ? Icons.done
                              : Icons.add
                        : Icons.edit,
                    color: colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.isCreatorProfile != null
                        ? userProfileController.isFollowingUser.value
                              ? AppLocalizations.of(context)!.following
                              : AppLocalizations.of(context)!.follow
                        : AppLocalizations.of(context)!.editProfile,
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(width: 10),

        widget.isCreatorProfile == null
            ? SizedBox(
                height: 50,
                width: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.settings);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: Icon(Icons.settings, color: colorScheme.onPrimary),
                ),
              )
            : Expanded(
                child: Obx(() {
                  final FriendsModel? friendModel =
                      friendsController.friendsList.firstWhereOrNull(
                        (friend) =>
                            (friend.senderId == widget.creator!.uid ||
                            friend.recieverId == widget.creator!.uid),
                      ) ??
                      friendsController.friendRequestsList.firstWhereOrNull(
                        (friend) =>
                            (friend.senderId == widget.creator!.uid ||
                            friend.recieverId == widget.creator!.uid),
                      );
                  return ElevatedButton(
                    onPressed: () async {
                      if (friendModel == null) {
                        await friendsController.sendFriendRequest(
                          widget.creator!.uid!,
                          widget.creator!.profileImageUrl!,
                          widget.creator!.userName!,
                          widget.creator!.name!,
                          widget.creator!.userRating!,
                        );

                        customSnackbar(
                          AppLocalizations.of(context)!.friendRequestSent,
                          AppLocalizations.of(
                            context,
                          )!.friendRequestSentTo(widget.creator!.name!),
                          LogType.success,
                        );
                      } else {
                        if (friendModel.requestStatus ==
                            FriendRequestStatus.sent) {
                          if (friendModel.senderId == widget.creator!.uid) {
                            await friendsController.acceptFriendRequest(
                              friendModel,
                            );
                            customSnackbar(
                              AppLocalizations.of(
                                context,
                              )!.friendRequestAccepted,
                              AppLocalizations.of(
                                context,
                              )!.friendRequestAcceptedTo(widget.creator!.name!),
                              LogType.success,
                            );
                          } else {
                            await friendsController.removeFriend(friendModel);
                            customSnackbar(
                              AppLocalizations.of(
                                context,
                              )!.friendRequestCancelled,
                              AppLocalizations.of(
                                context,
                              )!.friendRequestCancelledTo(
                                widget.creator!.name!,
                              ),
                              LogType.info,
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: friendModel != null
                          ? (friendModel.requestStatus ==
                                    FriendRequestStatus.sent
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
                              ? (friendModel.requestStatus ==
                                        FriendRequestStatus.sent
                                    ? Icons.check
                                    : Icons.people)
                              : Icons.add,
                          color: colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          friendModel != null
                              ? (friendModel.requestStatus ==
                                        FriendRequestStatus.sent
                                    ? friendModel.senderId ==
                                              widget.creator!.uid
                                          ? AppLocalizations.of(context)!.accept
                                          : AppLocalizations.of(
                                              context,
                                            )!.requested
                                    : AppLocalizations.of(context)!.friends)
                              : AppLocalizations.of(context)!.addFriend,
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                      ],
                    ),
                  );
                }),
              ),
      ],
    );
  }

  Widget _buildStoriesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(left: UiSizes.width_20),
      width: double.maxFinite,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.isCreatorProfile != null
                  ? AppLocalizations.of(context)!.userCreatedStories
                  : AppLocalizations.of(context)!.yourStories,
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          Obx(
            () => _buildStoriesList(
              context,
              widget.isCreatorProfile != null
                  ? userProfileController.searchedUserStories
                  : exploreStoryController.userCreatedStories,
              widget.isCreatorProfile != null
                  ? AppLocalizations.of(context)!.userNoStories
                  : AppLocalizations.of(context)!.youNoStories,
            ),
          ),
          SizedBox(height: UiSizes.height_10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.isCreatorProfile != null
                  ? AppLocalizations.of(context)!.userLikedStories
                  : AppLocalizations.of(context)!.yourLikedStories,
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          Obx(
            () => _buildStoriesList(
              context,
              widget.isCreatorProfile != null
                  ? userProfileController.searchedUserLikedStories
                  : exploreStoryController.userLikedStories,
              widget.isCreatorProfile != null
                  ? AppLocalizations.of(context)!.userNoLikedStories
                  : AppLocalizations.of(context)!.youNoLikedStories,
            ),
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
                Image.asset(height: 150, width: 150, AppImages.emptyBoxImage),
                const SizedBox(height: 5),
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
          MaterialPageRoute(builder: (context) => StoryScreen(story: story)),
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
                //overflow: TextOverflow.ellipsis,
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
