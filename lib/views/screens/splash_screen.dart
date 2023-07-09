import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/splash_controller.dart';
import 'package:resonate/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var splashcontroller = Get.find<SplashController>();
  var authController = Get.find<AuthStateContoller>();

  startDisplayTimer() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      splashcontroller.allowedDisplay.value = true;
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
      body: SafeArea(
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 0.2434 * Get.height,
              width: 0.34 * Get.width,
              child: AnimatedSplashScreen.withScreenFunction(
                  splashIconSize: 0.2434 * Get.height,
                  splash: Image.asset("assets/images/resonate_logo.png"),
                  duration: 3000,
                  screenFunction: () async {
                    return const SizedBox();
                  },
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.fade,
                  backgroundColor: AppColor.bgBlackColor),
            ),
            SizedBox(
              height: 0.34 * Get.width,
              width: 0.0486 * Get.width,
              child: AnimatedSplashScreen.withScreenFunction(
                  splashIconSize: 0.2434 * Get.height,
                  splash: VerticalDivider(
                    width: 0.0486 * Get.width,
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
              width: 0.0243 * Get.width,
            ),
            SizedBox(
              height: 0.2434 * Get.height,
              width: 0.34 * Get.width,
              child: Obx(
                () => splashcontroller.allowedDisplay.value
                    ? AnimatedSplashScreen.withScreenFunction(
                        splash: Image.asset("assets/images/aossie_logo.png"),
                        duration: 2000,
                        screenFunction: () async {
                          return const SizedBox();
                        },
                        splashIconSize: 0.2434 * Get.height,
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
