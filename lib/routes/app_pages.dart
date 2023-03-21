import 'package:get/get.dart';
import 'package:resonate/modules/authentication/authentication_binding.dart';
import 'package:resonate/modules/authentication/email_verification_page.dart';
import 'package:resonate/modules/authentication/login_page.dart';
import 'package:resonate/modules/authentication/signup_page.dart';
import 'package:resonate/modules/profile/profile_binding.dart';
import 'package:resonate/modules/profile/profile_page.dart';
import 'package:resonate/routes/app_routes.dart';

class AppPages{
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthenticationBinding(),
    ),
    GetPage(
        name: AppRoutes.emailVerification,
        page: () => const EmailVerificationPage(),
        binding: AuthenticationBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
  ];
}