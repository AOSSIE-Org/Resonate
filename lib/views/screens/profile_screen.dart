import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/story.dart';
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
                  _buildProfileHeader(authController),
                  _buildEmailVerificationButton(
                      context, emailVerifyController, authController),
                  SizedBox(height: UiSizes.height_10),
                  _buildProfileButtons(),
                ],
              ),
            ),
            SizedBox(height: UiSizes.height_20),
            _buildStoriesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AuthStateController controller) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(Get.context!).colorScheme.secondary,
          backgroundImage: isCreatorProfile != null
              ? NetworkImage(creatorImgUrl ?? '')
              : NetworkImage(controller.profileImageUrl ?? ''),
          radius: UiSizes.width_66,
        ),
        SizedBox(width: UiSizes.width_20),
        Expanded(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  "@${isCreatorProfile != null ? '' : controller.userName}",
                  style: TextStyle(
                    fontSize: UiSizes.size_14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCreatorProfile == null && controller.isEmailVerified!)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Icon(Icons.verified_user_outlined, color: Colors.green),
                        SizedBox(width: 5),
                        Text("Verified user",
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
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

  Widget _buildProfileButtons() {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isCreatorProfile != null
                    ? const Icon(Icons.add)
                    : const Icon(Icons.edit),
                const SizedBox(width: 8),
                Text(isCreatorProfile != null ? "Follow" : "Edit Profile"),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (isCreatorProfile == null)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.settings);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10),
                  Text("Settings"),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStoriesSection() {
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
                  fontSize: UiSizes.size_16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          Obx(
           ()=> _buildStoriesList(
                exploreStoryController.userCreatedStories,
                isCreatorProfile != null
                    ? "User has not created any story"
                    : "You have not created any story"),
          ),
          SizedBox(height: UiSizes.height_10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              isCreatorProfile != null
                  ? "User Liked Stories"
                  : "Your Liked Stories",
              style: TextStyle(
                  fontSize: UiSizes.size_16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: UiSizes.height_5),
          Obx(
           ()=> _buildStoriesList(
                exploreStoryController.userLikedStories,
                isCreatorProfile != null
                    ? "User has not liked any story"
                    : "You have not liked any story"),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList(List<Story> stories, String noStoryTextToShow) {
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
                Image.asset(
                    height: 150, width: 150, AppImages.emptyBoxImage),
                const SizedBox(
                  height: 5,
                ),
                Text(noStoryTextToShow)
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
                color: Colors.black,
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
              ),
            ),
            Text(
              story.description,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: UiSizes.size_12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
