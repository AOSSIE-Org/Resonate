import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/app_images.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({super.key});

  final aboutAppScreenController = Get.put(AboutAppScreenController());

  // Method to share the app's GitHub repository link
  void _shareApp() {
    Share.share("Check out our GitHub repository: $githubRepoUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: UiSizes.height_200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: UiSizes.width_20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: UiSizes.height_10,
                        ),
                        Semantics(
                          label: "Resonate logo",
                          child: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(
                                  AppImages.resonateLogoImage,
                                ),
                                fit: BoxFit.cover,
                              ),
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: UiSizes.height_131,
                          ),
                        ),
                        Expanded(
                          child: MergeSemantics(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Resonate",
                                  style: TextStyle(
                                    fontSize: UiSizes.size_20,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    "${aboutAppScreenController.appVersion} | ${aboutAppScreenController.appBuildNumber} | Stable",
                                    // "0.0.0 | 1 | Stable",
                                    style: TextStyle(
                                      fontSize: UiSizes.size_12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: UiSizes.width_10,
                ),
                Expanded(
                  child: Container(
                    height: UiSizes.height_200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: UiSizes.width_20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: UiSizes.height_10,
                        ),
                        Semantics(
                          label: "aossie logo",
                          child: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage(AppImages.aossieLogoImage),
                                scale: 4,
                              ),
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: UiSizes.height_131,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                semanticsLabel: "aossie",
                                "AOSSIE",
                                style: TextStyle(
                                  fontSize: UiSizes.size_20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: UiSizes.height_10,
            ),
            Container(
              height: UiSizes.height_110,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Help to grow",
                      style: TextStyle(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: _shareApp, // Call the share method here
                        child: const Column(
                          children: [
                            Icon(Icons.share_rounded),
                            Text("Share"),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Column(
                          children: [
                            Icon(Icons.star_rate_outlined),
                            Text("Rate"),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: UiSizes.height_40,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      semanticsLabel: "About Resonate",
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_5,
                    ),
                    const Text(
                      "Resonate is a social media platform, where every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now. Dive into diverse discussions and topics. Find rooms that resonate with you and become a part of the community. Join the conversation! Explore rooms, connect with friends, and share your voice with the world.",
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
