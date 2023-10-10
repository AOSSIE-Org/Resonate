import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/network_controller.dart';
import 'package:resonate/controllers/password_strength_checker_controller.dart';
import 'package:resonate/controllers/splash_controller.dart';

import '../controllers/email_verify_controller.dart';

class AuthSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthStateController(), permanent: true);
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.lazyPut(() => AuthenticationController());
    Get.lazyPut(() => EmailVerifyController());
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => PasswordStrengthCheckerController());
  }
}
