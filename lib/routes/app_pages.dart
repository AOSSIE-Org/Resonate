import 'package:get/get.dart';
import 'package:resonate/bindings/auth_splash_bindings.dart';
import 'package:resonate/bindings/create_story_binding.dart';
import 'package:resonate/bindings/profile_binding.dart';
import 'package:resonate/controllers/friend_call_screen.dart';
import 'package:resonate/themes/theme_screen.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/screens/app_preferences_screen.dart';
import 'package:resonate/views/screens/create_story_screen.dart';
import 'package:resonate/views/screens/explore_screen.dart';
import 'package:resonate/views/screens/create_room_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/screens/live_chapter_screen.dart';
import 'package:resonate/views/screens/login_screen.dart';
import 'package:resonate/views/screens/notifications_screen.dart';
import 'package:resonate/views/screens/pair_chat_screen.dart';
import 'package:resonate/views/screens/pair_chat_users_screen.dart';
import 'package:resonate/views/screens/pairing_screen.dart';
import 'package:resonate/views/screens/edit_profile_screen.dart';
import 'package:resonate/views/screens/email_verification_screen.dart';
import 'package:resonate/views/screens/forgot_password_screen.dart';
import 'package:resonate/views/screens/onboarding_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/screens/ringing_screen.dart';
import 'package:resonate/views/screens/settings_screen.dart';
import 'package:resonate/views/screens/signup_screen.dart';
import 'package:resonate/views/screens/user_account_screen.dart';
import 'package:resonate/views/screens/change_email_screen.dart';
import 'package:resonate/views/screens/delete_account_screen.dart';
import 'package:resonate/views/screens/landing_screen.dart';
import 'package:resonate/views/screens/splash_screen.dart';
import 'package:resonate/views/screens/tabview_screen.dart';
import 'package:resonate/views/screens/reset_password_screen.dart';
import 'package:resonate/views/screens/user_blocked_screen.dart';
import 'package:resonate/views/screens/welcome_screen.dart';
import '../bindings/tabview_binding.dart';
import '../views/screens/about_app_screen.dart';
import '../views/screens/contribute_screen.dart';

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
      name: AppRoutes.loginScreen,
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
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
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
      name: AppRoutes.tabview,
      page: () => TabViewScreen(),
      binding: TabViewBinding(),
    ),
    GetPage(
      name: AppRoutes.createRoom,
      page: () => CreateRoomScreen(),
      binding: TabViewBinding(),
    ),
    GetPage(name: AppRoutes.pairing, page: () => PairingScreen()),
    GetPage(name: AppRoutes.pairChatUsers, page: () => PairChatUsersScreen()),
    GetPage(name: AppRoutes.pairChat, page: () => PairChatScreen()),
    GetPage(name: AppRoutes.settings, page: () => SettingsScreen()),
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
    GetPage(name: AppRoutes.changeEmail, page: () => ChangeEmailScreen()),
    GetPage(name: AppRoutes.welcomeScreen, page: () => WelcomeScreen()),
    // New Screens
    GetPage(name: AppRoutes.loginScreen, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.homeScreen, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.themeScreen, page: () => ThemeScreen()),
    GetPage(
      name: AppRoutes.userAccountScreen,
      page: () => const UserAccountScreen(),
    ),
    GetPage(name: AppRoutes.aboutApp, page: () => AboutAppScreen()),
    GetPage(
      name: AppRoutes.notificationsScreen,
      page: () => NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.contributeScreen,
      page: () => const ContributeScreen(),
    ),
    GetPage(name: AppRoutes.exploreScreen, page: () => const ExploreScreen()),
    GetPage(
      name: AppRoutes.createStoryScreen,
      page: () => const CreateStoryPage(),
      binding: CreateStoryBinding(),
    ),
    GetPage(name: AppRoutes.ringingScreen, page: () => RingingScreen()),
    GetPage(name: AppRoutes.friendCallScreen, page: () => FriendCallScreen()),
    GetPage(
      name: AppRoutes.userBlockedScreen,
      page: () => const UserBlockedScreen(),
    ),
    GetPage(name: AppRoutes.liveChapterScreen, page: () => LiveChapterScreen()),
    GetPage(
      name: AppRoutes.appPreferencesScreen,
      page: () => const AppPreferencesScreen(),
    ),
  ];
}
