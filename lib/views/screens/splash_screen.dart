import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/splash_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/enums/update_enums.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final splashController = Get.find<SplashController>();
  final authController = Get.find<AuthStateController>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Start delayed animations and navigation
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _setupTimers();
    });
  }

  Future<void> _setupTimers() async {
    // Initial delay before starting animations
    Timer(const Duration(milliseconds: 500), () {
      _animationController.forward();
    });

    // Delay before navigation
    Timer(const Duration(milliseconds: 3000), () async {
      final result = await Get.find<AboutAppScreenController>().checkForUpdate(
        onIgnore: () {
          authController.isUserLoggedIn();
          Get.offNamed(AppRoutes.landing);
          return true;
        },
        onLater: () {
          authController.isUserLoggedIn();
          Get.offNamed(AppRoutes.landing);
          return true;
        },
        onUpdate: () {
          authController.isUserLoggedIn();
          Get.offNamed(AppRoutes.landing);
          return true;
        },
        isManualCheck: false,
      );
      if (result == UpdateCheckResult.noUpdateAvailable ||
          result == UpdateCheckResult.checkFailed) {
        authController.isUserLoggedIn();
        Get.offNamed(AppRoutes.landing);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgBlackColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Resonate Logo
                SizedBox(
                  height: UiSizes.height_200,
                  width: UiSizes.width_140,
                  child: Image.asset(
                    AppImages.resonateLogoImage,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(width: UiSizes.width_5),

                // Vertical Divider
                SizedBox(
                  height: UiSizes.height_140,
                  width: UiSizes.width_20,
                  child: VerticalDivider(
                    width: UiSizes.width_20,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(width: UiSizes.width_10),

                // Aossie Logo
                SizedBox(
                  height: UiSizes.height_200,
                  width: UiSizes.width_140,
                  child: Image.asset(
                    AppImages.aossieLogoImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
