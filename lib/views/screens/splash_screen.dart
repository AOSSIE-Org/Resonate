import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/splash_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var splashController = Get.find<SplashController>();
  var authController = Get.find<AuthStateController>();

  startDisplayTimer() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      splashController.allowedDisplay.value = true;
    });
  }

  startAuthTimer() async {
    var duration = const Duration(seconds: 2, milliseconds: 500);
    return Timer(duration, () {
      authController.isUserLoggedIn();
    });
  }

  @override
  void initState() {
    startDisplayTimer();
    startAuthTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgBlackColor,
      body: SafeArea(
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: UiSizes.height_200,
              width: UiSizes.width_140,
              child: AnimatedSplashScreen.withScreenFunction(
                  splashIconSize: UiSizes.height_200,
                  splash: Image.asset(AppImages.resonateLogoImage),
                  duration: 3000,
                  screenFunction: () async {
                    return const SizedBox();
                  },
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.fade,
                  backgroundColor: AppColor.bgBlackColor),
            ),
            SizedBox(
              width: UiSizes.width_5,
            ),
            SizedBox(
              height: UiSizes.height_140,
              width: UiSizes.width_20,
              child: AnimatedSplashScreen.withScreenFunction(
                  splashIconSize: UiSizes.size_200,
                  splash: VerticalDivider(
                    width: UiSizes.width_20,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  duration: 3000,
                  screenFunction: () async {
                    return const SizedBox();
                  },
                  splashTransition: SplashTransition.scaleTransition,
                  pageTransitionType: PageTransitionType.fade,
                  backgroundColor: AppColor.bgBlackColor),
            ),
            SizedBox(
              width: UiSizes.width_10,
            ),
            SizedBox(
              height: UiSizes.height_200,
              width: UiSizes.width_140,
              child: Obx(
                () => splashController.allowedDisplay.value
                    ? AnimatedSplashScreen.withScreenFunction(
                        splash: Image.asset(AppImages.aossieLogoImage),
                        duration: 2000,
                        screenFunction: () async {
                          return const SizedBox();
                        },
                        splashIconSize: UiSizes.size_200,
                        splashTransition: SplashTransition.fadeTransition,
                        pageTransitionType: PageTransitionType.fade,
                        backgroundColor: AppColor.bgBlackColor)
                    : const SizedBox(),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
