import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/splash_controller.dart';

class AuthSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthStateController(), permanent: true);
    Get.lazyPut(() => AuthenticationController());
    Get.lazyPut(() => SplashController());
  }
}
