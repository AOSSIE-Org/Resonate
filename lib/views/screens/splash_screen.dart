import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/views/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
        builder: (controller) => AnimatedSplashScreen.withScreenFunction(
            splashIconSize: 200,
            splash: Image.asset("assets/images/aossie_logo.png"),
            duration: 3000,
            screenFunction: () async {
              controller.isUserLoggedIn();
              return const SizedBox();
            },
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: AppColor.bgBlackColor));
  }
}
