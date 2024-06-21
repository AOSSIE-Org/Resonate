import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: OnBoardingSlider(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SvgPicture.asset(
            "assets/svg/resonate_logo_white.svg",
            height: 30,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        controllerColor: Theme.of(context).colorScheme.primary,
        hasFloatingButton: true,
        headerBackgroundColor: Theme.of(context).colorScheme.background,
        finishButtonTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: UiSizes.size_18,
        ),
        skipIcon: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onFinish: () async {
          await GetStorage().write("landingScreenShown", true);
          Get.offNamed(AppRoutes.newWelcomeScreen);
        },
        finishButtonText: 'Get Started',
        skipTextButton: const Text('Skip'),
        background: [
          LandingImage(
            imagePath: AppImages.landingFirstImage,
            initialHeight: UiSizes.height_82,
            imageHeight: UiSizes.height_246,
            imageWidth: UiSizes.width_45,
          ),
          LandingImage(
            imagePath: AppImages.landingSecondImage,
            initialHeight: UiSizes.height_90,
            imageHeight: UiSizes.height_246,
            imageWidth: UiSizes.width_40,
          ),
          LandingImage(
            imagePath: AppImages.landingThirdImage,
            initialHeight: UiSizes.height_90,
            imageHeight: UiSizes.height_246,
            imageWidth: UiSizes.width_56,
          ),
        ],
        totalPage: 3,
        speed: 1,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: UiSizes.height_200 * 2,
                ),
                Text(
                  'Welcome to Resonate',
                  style: TextStyle(fontSize: UiSizes.size_23),
                ),
                SizedBox(
                  height: UiSizes.height_16,
                ),
                Text(
                  "Join the conversation! Explore rooms, connect with friends, and share your voice with the world.",
                  style: TextStyle(fontSize: UiSizes.size_15),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: UiSizes.height_200 * 2,
                ),
                Text(
                  'Explore Diverse Conversations',
                  style: TextStyle(fontSize: UiSizes.size_23),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: UiSizes.height_20,
                ),
                Text(
                  "Dive into diverse discussions and topics. \nFind rooms that resonate with you and become a part of the community.",
                  style: TextStyle(fontSize: UiSizes.size_15),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: UiSizes.height_200 * 2,
                ),
                Text(
                  'Your Voice Matters',
                  style: TextStyle(fontSize: UiSizes.size_23),
                ),
                SizedBox(
                  height: UiSizes.height_16,
                ),
                Text(
                  "At Resonate, every voice is valued. Share your thoughts, stories, and experiences with others. Start your audio journey now.",
                  style: TextStyle(fontSize: UiSizes.size_15),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class LandingImage extends StatelessWidget {
  LandingImage({
    super.key,
    required this.imagePath,
    required this.initialHeight,
    required this.imageHeight,
    required this.imageWidth,
  });

  String imagePath;
  double initialHeight;
  double imageHeight;
  double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: initialHeight,
        ),
        Row(
          children: [
            SizedBox(
              width: imageWidth,
            ),
            Image.asset(
              imagePath,
              height: imageHeight,
            ),
          ],
        ),
      ],
    );
  }
}
