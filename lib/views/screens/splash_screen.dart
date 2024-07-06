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
import 'package:resonate/routes/app_routes.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
      Get.offNamed(AppRoutes.landing);
    });
  }

 @override
  void initState() {
    super.initState();
    startDisplayTimer();
    startAuthTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgBlackColor,
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
            SizedBox(
              height: UiSizes.height_200,
              width: UiSizes.width_140,
              child: Obx(() {
                  if (splashController.allowedDisplay.value ?? false) {
                    return AnimatedSplashScreen.withScreenFunction(
                      splashIconSize: UiSizes.height_200,
                      splash: Image.asset(AppImages.resonateLogoImage),
                      duration: 3000,
                      screenFunction: () async {
                        return const SizedBox();
                      },
                      splashTransition: SplashTransition.fadeTransition,
                      pageTransitionType: PageTransitionType.fade,
                      backgroundColor: AppColor.bgBlackColor,
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            SizedBox(
              width: UiSizes.width_5,
            ),
            SizedBox(
              height: UiSizes.height_140,
              width: UiSizes.width_20,
              child: Obx(() {
                  if (splashController.allowedDisplay.value ?? false) {
                    return AnimatedSplashScreen.withScreenFunction(
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
                      backgroundColor: AppColor.bgBlackColor,
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            SizedBox(
              width: UiSizes.width_10,
            ),
            SizedBox(
              height: UiSizes.height_200,
              width: UiSizes.width_140,
              child: Obx(() {
                  if (splashController.allowedDisplay.value ?? false) {
                    return AnimatedSplashScreen.withScreenFunction(
                      splash: Image.asset(AppImages.aossieLogoImage),
                      duration: 2000,
                      screenFunction: () async {
                        return const SizedBox();
                      },
                      splashIconSize: UiSizes.size_200,
                      splashTransition: SplashTransition.fadeTransition,
                      pageTransitionType: PageTransitionType.fade,
                      backgroundColor: AppColor.bgBlackColor,
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
          ]),
        ),
      ),
    );
  }
}
