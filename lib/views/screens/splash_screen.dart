import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/splash_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
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
    // Begin the fade-in animation after a brief delay (non-blocking).
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _animationController.forward();
    });

    // Run the minimum splash display time and the auth resolution concurrently.
    // AuthStateController.onInit() already kicked off setUserProfileData(), so
    // we simply wait for that in-flight request to settle rather than issuing a
    // second network call. This prevents any intermediate screen from appearing
    // and eliminates the startup auth flicker.
    await Future.wait<void>([
      Future.delayed(const Duration(milliseconds: 3000)),
      _waitForAuthResolution(),
    ]);
    if (!mounted) return;

    // After both the minimum display time and the auth check have completed,
    // optionally prompt for an update. Navigation is always delegated to
    // navigateBasedOnAuthState() so the landing screen is never rendered as an
    // unintended intermediate step.
    final result = await Get.find<AboutAppScreenController>().checkForUpdate(
      onIgnore: () {
        authController.navigateBasedOnAuthState();
        return true;
      },
      onLater: () {
        authController.navigateBasedOnAuthState();
        return true;
      },
      onUpdate: () {
        authController.navigateBasedOnAuthState();
        return true;
      },
      isManualCheck: false,
    );
    if (result == UpdateCheckResult.noUpdateAvailable ||
        result == UpdateCheckResult.checkFailed) {
      authController.navigateBasedOnAuthState();
    }
  }

  /// Returns a [Future] that completes as soon as [AuthStateController.authStatus]
  /// leaves [AuthStatus.checking].
  ///
  /// If the auth check is already resolved (fast local session cache), this
  /// completes on the very next microtask so no extra delay is introduced.
  Future<void> _waitForAuthResolution() async {
    if (authController.authStatus.value != AuthStatus.checking) return;

    final completer = Completer<void>();
    final worker = ever<AuthStatus>(
      authController.authStatus,
      (AuthStatus status) {
        if (status != AuthStatus.checking && !completer.isCompleted) {
          completer.complete();
        }
      },
    );
    await completer.future;
    worker.dispose();
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
