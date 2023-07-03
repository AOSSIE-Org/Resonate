import 'package:get/get.dart';
import 'package:resonate/bindings//authentication_binding.dart';
import 'package:resonate/bindings/profile_binding.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/screens/create_room_screen.dart';
import 'package:resonate/views/screens/email_verification_screen.dart';
import 'package:resonate/views/screens/login_screen.dart';
import 'package:resonate/views/screens/onboarding_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/screens/signup_screen.dart';
import 'package:resonate/views/screens/tabview_screen.dart';

import '../bindings/tabview_binding.dart';
import '../views/screens/home_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => const EmailVerificationScreen(),
      binding: AuthenticationBinding(),
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
      page: () => const HomeScreen(),
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
