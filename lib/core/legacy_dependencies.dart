import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/controllers/network_controller.dart';
import 'package:resonate/controllers/onboarding_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';

// Registers the GetX controllers that are still in use post-rooms-migration.
void setupLegacyGetXDependencies() {
  Get.put<NetworkController>(NetworkController(), permanent: true);
  Get.lazyPut(() => TabViewController());
  Get.lazyPut(() => OnboardingController());
  Get.lazyPut(() => ExploreStoryController());
  Get.lazyPut(() => FriendsController(), fenix: true);
}
