import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        controllerColor: AppColor.yellowColor,
        hasFloatingButton: true,
        headerBackgroundColor: AppColor.bgBlackColor,
        finishButtonTextStyle: TextStyle(
          color: AppColor.bgBlackColor,
        ),
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: AppColor.yellowMaterialColor,
          elevation: 10,
        ),
        skipIcon: Icon(
          Icons.arrow_forward,
          color: AppColor.bgBlackColor,
        ),
        onFinish: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool("initScreenShown", true);

          Get.offNamed(AppRoutes.login);
        },
        finishButtonText: 'Get Started',
        skipTextButton: Text('Skip'),
        background: [
          LandingImage(
            ImagePath: 'assets/images/no_room.png',
            InitialHeight: UiSizes.height_140,
            ImageHeight: UiSizes.height_200,
          ),
          LandingImage(
            ImagePath: 'assets/images/no_room.png',
            InitialHeight: UiSizes.height_140,
            ImageHeight: UiSizes.height_200,
          ),
          LandingImage(
            ImagePath: 'assets/images/no_room.png',
            InitialHeight: UiSizes.height_140,
            ImageHeight: UiSizes.height_200,
          ),
        ],
        totalPage: 3,
        speed: 1,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: UiSizes.height_200 * 2,
                ),
                Text('Description Text 1'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: UiSizes.height_200 * 2,
                ),
                Text('Description Text 2'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: UiSizes.height_200 * 2,
                ),
                Text('Description Text 3'),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: AppColor.bgBlackColor,
    );
  }
}

// ignore: must_be_immutable
class LandingImage extends StatelessWidget {
  LandingImage({
    required this.ImagePath,
    required this.InitialHeight,
    required this.ImageHeight,
  });
  String ImagePath;
  double InitialHeight;
  double ImageHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: InitialHeight,
        ),
        Row(
          children: [
            SizedBox(
              width: UiSizes.width_16,
            ),
            Image.asset(
              ImagePath,
              height: ImageHeight,
            ),
          ],
        ),
      ],
    );
  }
}
