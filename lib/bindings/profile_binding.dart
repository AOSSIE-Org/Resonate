import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/onboarding_controller.dart';


class ProfileBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AuthStateController());
    Get.lazyPut(() => AuthenticationController());
    Get.lazyPut(() => OnboardingController());
  }
}