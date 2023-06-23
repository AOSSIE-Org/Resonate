import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/splash_controller.dart';
import 'package:resonate/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var splashcontroller = Get.find<SplashController>();
  var authController = Get.find<AuthenticationController>();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 200,
              width: 140,
              child: AnimatedSplashScreen.withScreenFunction(
                  splashIconSize: 200,
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
              height: 140,
              width: 20,
              child: AnimatedSplashScreen.withScreenFunction(
                  splashIconSize: 200,
                  splash: const VerticalDivider(
                    width: 20,
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
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 200,
              width: 140,
              child: Obx(
                () => splashcontroller.allowedDisplay.value
                    ? AnimatedSplashScreen.withScreenFunction(
                        splash: Image.asset("assets/images/aossie_logo.png"),
                        duration: 2000,
                        screenFunction: () async {
                          return const SizedBox();
                        },
                        splashIconSize: 200,
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
