import 'package:get/get.dart';
import 'package:resonate/bindings//authentication_binding.dart';
import 'package:resonate/bindings/profile_binding.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/views/screens/email_verification_screen.dart';
import 'package:resonate/views/screens/login_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/screens/signup_screen.dart';

class AppPages{
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
  ];
}