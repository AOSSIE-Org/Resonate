import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/l10n/app_localizations.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(toolbarHeight: 0),
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
        headerBackgroundColor: Theme.of(context).colorScheme.surface,
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
          Get.offNamed(AppRoutes.welcomeScreen);
        },
        finishButtonText: AppLocalizations.of(context)!.getStarted,
        skipTextButton: Text(AppLocalizations.of(context)!.skip),
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
                SizedBox(height: UiSizes.height_200 * 2),
                Text(
                  AppLocalizations.of(context)!.welcomeToResonate,
                  style: TextStyle(fontSize: UiSizes.size_23),
                ),
                SizedBox(height: UiSizes.height_16),
                Text(
                  AppLocalizations.of(context)!.joinConversationExploreRooms,
                  style: TextStyle(fontSize: UiSizes.size_15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: Column(
              children: <Widget>[
                SizedBox(height: UiSizes.height_200 * 2),
                Text(
                  AppLocalizations.of(context)!.exploreDiverseConversations,
                  style: TextStyle(fontSize: UiSizes.size_23),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: UiSizes.height_20),
                Text(
                  AppLocalizations.of(context)!.diveIntoDiverseDiscussions,
                  style: TextStyle(fontSize: UiSizes.size_15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: Column(
              children: <Widget>[
                SizedBox(height: UiSizes.height_200 * 2),
                Text(
                  AppLocalizations.of(context)!.yourVoiceMatters,
                  style: TextStyle(fontSize: UiSizes.size_23),
                ),
                SizedBox(height: UiSizes.height_16),
                Text(
                  AppLocalizations.of(context)!.atResonateEveryVoiceValued,
                  style: TextStyle(fontSize: UiSizes.size_15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LandingImage extends StatelessWidget {
  const LandingImage({
    super.key,
    required this.imagePath,
    required this.initialHeight,
    required this.imageHeight,
    required this.imageWidth,
  });

  final String imagePath;
  final double initialHeight;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: initialHeight),
        Row(
          children: [
            SizedBox(width: imageWidth),
            Image.asset(imagePath, height: imageHeight),
          ],
        ),
      ],
    );
  }
}
