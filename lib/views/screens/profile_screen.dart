import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/views/screens/story_screen.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/ui_sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailVerifyController =
        Get.put<EmailVerifyController>(EmailVerifyController());

    return GetBuilder<AuthStateController>(
      builder: (controller) => Scaffold(
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
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            backgroundImage:
                                NetworkImage(controller.profileImageUrl ?? ''),
                            radius: UiSizes.width_66,
                          ),
                          SizedBox(
                            width: UiSizes.width_20,
                          ),
                          Expanded(
                            child: MergeSemantics(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.displayName.toString(),
                                    style: TextStyle(
                                      fontSize: UiSizes.size_24,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "@${controller.userName}",
                                    style: TextStyle(
                                      fontSize: UiSizes.size_14,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  (controller.isEmailVerified!)
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.verified_user_outlined,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Verified user",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (!controller.isEmailVerified!)
                        ? Container(
                            margin: EdgeInsets.only(
                              top: UiSizes.height_10,
                            ),
                            width: double.maxFinite,
                            child: OutlinedButton(
                              onPressed: () {
                                // Display Loading Dialog
                                loadingDialog(context);
                                emailVerifyController.isSending.value = true;
                                emailVerifyController.sendOTP();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified_user_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Verify Email"),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: UiSizes.height_10,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 34,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.editProfile);
                                },
                                child: const FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Edit Profile"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: UiSizes.width_5,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 34,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.settings);
                                },
                                child: const FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.settings),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Settings"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: UiSizes.height_20,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: UiSizes.width_20,
                ),
                width: double.maxFinite,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your Stories",
                        style: TextStyle(
                          fontSize: UiSizes.size_16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_5,
                    ),
                    SizedBox(
                      height: UiSizes.height_200,
                      child: ListView.builder(
                        itemCount: exploreStoryController.userCreatedStories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryScreen(
                                    story: exploreStoryController.userCreatedStories[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: UiSizes.height_140,
                              margin: EdgeInsets.only(
                                right: UiSizes.width_10,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: UiSizes.height_140,
                                    width: UiSizes.height_140,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            exploreStoryController.userCreatedStories[index].coverImageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: UiSizes.height_5,
                                  ),
                                  Text(
                                    exploreStoryController.userCreatedStories[index].title,
                                    style: TextStyle(
                                      fontSize: UiSizes.size_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                               exploreStoryController.userCreatedStories[index].description,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: UiSizes.size_12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your Liked Stories",
                        style: TextStyle(
                          fontSize: UiSizes.size_16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_5,
                    ),
                    SizedBox(
                      height: UiSizes.height_200,
                      child: ListView.builder(
                        itemCount: exploreStoryController.userLikedStories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryScreen(
                                    story: exploreStoryController.userLikedStories[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: UiSizes.height_140,
                              margin: EdgeInsets.only(
                                right: UiSizes.width_10,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: UiSizes.height_140,
                                    width: UiSizes.height_140,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            exploreStoryController.userLikedStories[index].coverImageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: UiSizes.height_5,
                                  ),
                                  Text(
                                    exploreStoryController.userLikedStories[index].title,
                                    style: TextStyle(
                                      fontSize: UiSizes.size_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    exploreStoryController.userLikedStories[index].description,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: UiSizes.size_12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
