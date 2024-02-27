//import required packages
import 'package:get/get.dart';
import 'package:resonate/bindings/auth_splash_bindings.dart';
import 'package:resonate/bindings/profile_binding.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/screens/create_room_screen.dart';
import 'package:resonate/views/screens/delete_account_screen.dart';
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

//AppRoutes can be found in lib\routes\app_routes.dart
//AppPages contains a list of pages of type GetPage
//GetPage is an handy way of managing app navigation
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      //name takes a string which acts as route name associated with the page
      name: AppRoutes.splash,
      //page is a function that returns a widget.
      //whenever I navigate to AppRoutes.splash SplashScreen widget will be created.
      page: () => const SplashScreen(),
      //binding is used to perform certain actions on page before the page is created.
      binding: AuthSplashBinding(),
    ),
    //In this list member,
    //The landing screen has the route name AppRoutes.landing, displays the LandingScreen widget when we move to AppRoutes.landing,
    //and also uses the AuthSplashBinding for binding.
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
      page: () => DiscussionScreen(),
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
    GetPage(
      name: AppRoutes.deleteAccount,
      page: () => const DeleteAccountScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
