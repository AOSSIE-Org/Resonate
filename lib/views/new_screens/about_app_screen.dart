import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({super.key});

  final aboutAppScreenController = Get.put(AboutAppScreenController());

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
                        Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/resonate_logo.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: UiSizes.height_131,
                        ),
                        Expanded(
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
                        Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image:
                                  AssetImage("assets/images/aossie_logo.png"),
                              scale: 4,
                            ),
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: UiSizes.height_131,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
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
            Row(
              children: [
                Expanded(
                  child: Container(
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
                              onTap: () {},
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
                ),
                SizedBox(
                  width: UiSizes.width_10,
                ),
                const Expanded(
                  child: SizedBox(),
                )
              ],
            ),
            SizedBox(
              height: UiSizes.height_40,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
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
          ],
        ),
      ),
    );
  }
}
