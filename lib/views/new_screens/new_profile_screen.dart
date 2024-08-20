import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/views/new_screens/story_screen.dart';
import 'package:resonate/views/new_widgets/new_loading_dialog.dart';

import '../../controllers/auth_state_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../models/mock_models/stories_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/ui_sizes.dart';

class NewProfileScreen extends StatelessWidget {
  NewProfileScreen({super.key});

  final List<StoriesModel> yourStories = [
    StoriesModel(
      title: "Sony",
      description:
          "Discover a wide range of high-quality products from Sony and the technology behind them, get instant access to our store and Entertainment Network.",
      imgUrl: "assets/mock/sony.jpeg",
    ),
    StoriesModel(
      title: "Coffee Girl",
      description: "Morning coffee is good for health or not.",
      imgUrl: "assets/mock/coffee_girl.jpeg",
    ),
    StoriesModel(
      title: "Japan",
      description: "Japan is a country with very religious people.",
      imgUrl: "assets/mock/japan.jpeg",
    ),
  ];

  final List<StoriesModel> continueWithStories = [
    StoriesModel(
      title: "Podcast",
      description: "The sun dipped below the horizon, casting a warm, golden hue over the tranquil landscape. Birds began their evening songs, filling the air with a gentle melody that blended perfectly with the rustling of the leaves in the cool breeze.",
      imgUrl: "assets/mock/podcast.jpeg",
    ),
    StoriesModel(
      title: "Coffee Latte",
      description: "Cafe latte is good for health or not.",
      imgUrl: "assets/mock/cafe_latte.jpeg",
    ),
  ];

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
                                newLoadingDialog(context);

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
                        itemCount: yourStories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryScreen(
                                    storyModel: yourStories[index],
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
                                        image:
                                            AssetImage(yourStories[index].imgUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: UiSizes.height_5,
                                  ),
                                  Text(
                                    yourStories[index].title,
                                    style: TextStyle(
                                      fontSize: UiSizes.size_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    yourStories[index].description,
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
                        "Continue with",
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
                        itemCount: continueWithStories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryScreen(
                                    storyModel: continueWithStories[index],
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
                                            continueWithStories[index].imgUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: UiSizes.height_5,
                                  ),
                                  Text(
                                    continueWithStories[index].title,
                                    style: TextStyle(
                                      fontSize: UiSizes.size_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    continueWithStories[index].description,
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
