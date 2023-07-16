import 'package:get/get.dart';
import 'package:resonate/bindings/auth_splash_bindings.dart';
import 'package:resonate/bindings/profile_binding.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/screens/create_room_screen.dart';
import 'package:resonate/views/screens/email_verification_screen.dart';
import 'package:resonate/views/screens/login_screen.dart';
import 'package:resonate/views/screens/onboarding_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/screens/signup_screen.dart';
import 'package:resonate/views/screens/splash_screen.dart';
import 'package:resonate/views/screens/tabview_screen.dart';

import '../bindings/tabview_binding.dart';
import '../views/screens/home_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
      GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: AuthSplashBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(),
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
      page: () => OnBoardingScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      //binding: ProfileBinding(),
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
  ];
}
