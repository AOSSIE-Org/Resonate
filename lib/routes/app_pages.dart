import 'package:get/get.dart';
import 'package:resonate/bindings/auth_splash_bindings.dart';
import 'package:resonate/bindings/profile_binding.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/screens/create_room_screen.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/edit_profile_screen.dart';
import 'package:resonate/views/screens/email_verification_screen.dart';
import 'package:resonate/views/screens/landing_screen.dart';
import 'package:resonate/views/screens/login_screen.dart';
import 'package:resonate/views/screens/onboarding_screen.dart';
import 'package:resonate/views/screens/pairing_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/screens/settings_screen.dart';
import 'package:resonate/views/screens/signup_screen.dart';
import 'package:resonate/views/screens/splash_screen.dart';
import 'package:resonate/views/screens/tabview_screen.dart';

import '../bindings/tabview_binding.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/pair_chat_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.landing,
      page: () => const LandingScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => EmailVerificationScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.onBoarding,
      page: () => const OnBoardingScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      binding: TabViewBinding(),
    ),
    GetPage(
      name: AppRoutes.tabview,
      page: () => TabViewScreen(),
      binding: TabViewBinding(),
    ),
    GetPage(
      name: AppRoutes.createRoom,
      page: () => CreateRoomScreen(),
      binding: TabViewBinding(),
    ),
    GetPage(
      name: AppRoutes.discuss,
      page: () => const DiscussionScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.pairing,
      page: () => PairingScreen(),
    ),
    GetPage(
      name: AppRoutes.pairChat,
      page: () => PairChatScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => EditProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
