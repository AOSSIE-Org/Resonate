import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/onboarding_controller.dart';
import 'package:resonate/controllers/profile_controller.dart';


class ProfileBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => AuthenticationController());
    Get.lazyPut(() => OnboardingController());
  }
}