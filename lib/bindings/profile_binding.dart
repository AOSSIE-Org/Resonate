import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/controllers/onboarding_controller.dart';
import 'package:resonate/themes/theme_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthStateController());
    Get.lazyPut(() => AuthenticationController());
    Get.lazyPut(() => OnboardingController());
    Get.lazyPut(() => ExploreStoryController());
    Get.lazyPut(() => ThemeController());
  }
}
