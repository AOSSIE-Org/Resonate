import 'package:get/get.dart';
import 'package:resonate/bindings/auth_splash_bindings.dart';
import 'package:resonate/bindings/profile_binding.dart';
import 'package:resonate/new_themes/theme_screen.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/new_screens/new_create_room_screen.dart';
import 'package:resonate/views/new_screens/new_home_screen.dart';
import 'package:resonate/views/new_screens/new_login_screen.dart';
import 'package:resonate/views/new_screens/new_notifications_screen.dart';
import 'package:resonate/views/new_screens/new_room_chat_screen.dart';
import 'package:resonate/views/new_screens/new_room_screen.dart';
import 'package:resonate/views/new_screens/new_tab_view.dart';
import 'package:resonate/views/new_screens/new_welcome_screen.dart';

import 'package:resonate/views/new_screens/new_edit_profile_screen.dart';
import 'package:resonate/views/new_screens/new_email_verification_screen.dart';
import 'package:resonate/views/new_screens/new_forgot_password_screen.dart';
import 'package:resonate/views/new_screens/new_onboarding_screen.dart';
import 'package:resonate/views/new_screens/new_profile_screen.dart';
import 'package:resonate/views/new_screens/new_settings_screen.dart';
import 'package:resonate/views/new_screens/new_signup_screen.dart';
import 'package:resonate/views/new_screens/user_account_screen.dart';
import 'package:resonate/views/screens/change_email_screen.dart';
import 'package:resonate/views/screens/create_room_screen.dart';
import 'package:resonate/views/screens/delete_account_screen.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/landing_screen.dart';
import 'package:resonate/views/screens/pairing_screen.dart';
import 'package:resonate/views/screens/splash_screen.dart';
import 'package:resonate/views/screens/tabview_screen.dart';
import 'package:resonate/views/screens/reset_password_screen.dart';

import '../bindings/tabview_binding.dart';
import '../views/new_screens/about_app_screen.dart';
import '../views/new_screens/contribute_screen.dart';
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
    // GetPage(
    //   name: AppRoutes.signup,
    //   page: () => const SignupScreen(),
    //   binding: AuthSplashBinding(),
    // ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const NewSignupScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => NewEmailVerificationScreen(),
      binding: AuthSplashBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.emailVerification,
    //   page: () => EmailVerificationScreen(),
    //   binding: AuthSplashBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => const LoginScreen(),
    //   binding: AuthSplashBinding(),
    // ),
    GetPage(
      name: AppRoutes.newLoginScreen,
      page: () => const NewLoginScreen(),
      binding: AuthSplashBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => ProfileScreen(),
    //   binding: ProfileBinding(),
    // ),
    GetPage(
      name: AppRoutes.profile,
      page: () => NewProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.onBoarding,
      page: () => const NewOnBoardingScreen(),
      binding: ProfileBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.onBoarding,
    //   page: () => const OnBoardingScreen(),
    //   binding: ProfileBinding(),
    // ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const NewForgotPasswordScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
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
      page: () => NewSettingsScreen(),
    ),
    // GetPage(
    //   name: AppRoutes.settings,
    //   page: () => const SettingsScreen(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.editProfile,
    //   page: () => EditProfileScreen(),
    //   binding: ProfileBinding(),
    // ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => NewEditProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.deleteAccount,
      page: () => const DeleteAccountScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.changeEmail,
      page: () => ChangeEmailScreen(),
    ),
    // New Screens
    GetPage(
      name: AppRoutes.newWelcomeScreen,
      page: () => const NewWelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.newLoginScreen,
      page: () => const NewLoginScreen(),
    ),
    GetPage(
      name: AppRoutes.newRoomScreen,
      page: () => const NewRoomScreen(),
    ),
    GetPage(
      name: AppRoutes.newRoomScreen,
      page: () => NewRoomChatScreen(),
    ),
    GetPage(
      name: AppRoutes.newBottomNavBar,
      page: () => const BottomNavBar(),
    ),
    GetPage(
      name: AppRoutes.newHomeScreen,
      page: () => const NewHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.newCreateRoom,
      page: () => const StartRoomBottomSheet(),
    ),
    GetPage(
      name: AppRoutes.themeScreen,
      page: () => ThemeScreen(),
    ),
    GetPage(
      name: AppRoutes.userAccountScreen,
      page: () => const UserAccountScreen(),
    ),
    GetPage(
      name: AppRoutes.aboutApp,
      page: () => AboutAppScreen(),
    ),
    GetPage(
      name: AppRoutes.newNotificationsScreen,
      page: () => NewNotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.contributeScreen,
      page: () => const ContributeScreen(),
    ),
  ];
}
