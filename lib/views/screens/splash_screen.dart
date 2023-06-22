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
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 300),
          child: SizedBox(
            height: 200,
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
        ),
        Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Obx(
              () => splashcontroller.allowedDisplay.value
                  ? SizedBox(
                      height: 90,
                      child: AnimatedSplashScreen.withScreenFunction(
                          splash: Image.asset("assets/images/aossie_logo.png"),
                          duration: 2000,
                          screenFunction: () async {
                            return const SizedBox();
                          },
                          splashIconSize: 90,
                          splashTransition: SplashTransition.fadeTransition,
                          pageTransitionType: PageTransitionType.fade,
                          backgroundColor: AppColor.bgBlackColor),
                    )
                  : const SizedBox(),
            ))
      ]),
    );
  }
}
