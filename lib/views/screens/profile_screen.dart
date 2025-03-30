import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/views/screens/story_screen.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_images.dart';
import '../../utils/ui_sizes.dart';

class ProfileScreen extends StatelessWidget {
  final String? creatorName;
  final String? creatorImgUrl;
  final bool? isCreatorProfile;

  ProfileScreen({
    Key? key,
    this.creatorName,
    this.creatorImgUrl,
    this.isCreatorProfile,
  }) : super(key: key);

  final emailVerifyController =
  Get.put<EmailVerifyController>(EmailVerifyController());
  final authController = Get.find<AuthStateController>();
  final exploreStoryController = Get.find<ExploreStoryController>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
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
                  _buildProfileHeader(context, authController),
                  _buildEmailVerificationButton(
                      context, emailVerifyController, authController),
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
    );
  }

  Widget _buildProfileHeader(
      BuildContext context,
      AuthStateController controller,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(width: UiSizes.width_20),
        GetBuilder<ThemeController>(
          builder: (themeController) => CircleAvatar(
            backgroundColor: colorScheme.secondary,
            backgroundImage: isCreatorProfile != null
                ? NetworkImage(creatorImgUrl ?? '')
                : controller.profileImageUrl == null ||
                controller.profileImageUrl!.isEmpty
                ? NetworkImage(
              themeController.userProfileImagePlaceholderUrl,
            )
                : NetworkImage(controller.profileImageUrl ?? ''),
            radius: UiSizes.width_66,
          ),
        ),
        SizedBox(width: UiSizes.width_20),
        Expanded(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isCreatorProfile == null && controller.isEmailVerified!)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Icon(Icons.verified_user_outlined,
                            color: Colors.green),
                        const SizedBox(width: 5),
                        const Text("Verified",
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                Text(
                  isCreatorProfile != null
                      ? creatorName ?? ''
                      : controller.displayName.toString(),
                  style: TextStyle(
                    fontSize: UiSizes.size_24,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    "@${isCreatorProfile != null ? '' : controller.userName}",
                    style: TextStyle(
                      fontSize: UiSizes.size_14,
                      overflow: TextOverflow.ellipsis,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colorScheme.outline),
                  ),
                  backgroundColor: colorScheme.surfaceVariant,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: UiSizes.width_20),
      ],
    );
  }

  Widget _buildEmailVerificationButton(
      BuildContext context,
      EmailVerifyController emailVerifyController,
      AuthStateController controller) {
    if (isCreatorProfile != null || controller.isEmailVerified!) {
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user_outlined),
            SizedBox(width: 10),
            Text("Verify Email"),
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
          child: ElevatedButton(
            onPressed: () {
              if (isCreatorProfile != null) {
                // Implement follow functionality
              } else {
                Get.toNamed(AppRoutes.editProfile);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCreatorProfile != null ? Icons.add : Icons.edit,
                  color: colorScheme.onPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  isCreatorProfile != null ? "Follow" : "Edit Profile",
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (isCreatorProfile == null)
          SizedBox(
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
              isCreatorProfile != null
                  ? "User Created Stories"
                  : "Your Stories",
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          Obx(
                () => _buildStoriesList(
              context,
              exploreStoryController.userCreatedStories,
              isCreatorProfile != null
                  ? "User has not created any story"
                  : "You have not created any story",
            ),
          ),
          SizedBox(height: UiSizes.height_10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isCreatorProfile != null
                  ? "User Liked Stories"
                  : "Your Liked Stories",
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          Obx(
                () => _buildStoriesList(
              context,
              exploreStoryController.userLikedStories,
              isCreatorProfile != null
                  ? "User has not liked any story"
                  : "You have not liked any story",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(
      BuildContext context, List<Story> stories, String noStoryTextToShow) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: UiSizes.height_200,
      child: stories.isNotEmpty
          ? ListView.builder(
        itemCount: stories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return StoryItem(
            story: stories[index],
          );
        },
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(height: 150, width: 150, AppImages.emptyBoxImage),
          const SizedBox(height: 5),
          Text(noStoryTextToShow, style: TextStyle(color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  const StoryItem({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryScreen(
              story: story,
            ),
          ),
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
                color: colorScheme.surfaceVariant,
                image: DecorationImage(
                  image: NetworkImage(story.coverImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: UiSizes.height_5),
            Text(
              story.title,
              style: TextStyle(
                fontSize: UiSizes.size_16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              story.description,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
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