import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/controllers/network_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';

// Registers the GetX controllers that are still in use after the auth,
// rooms, profile, and friends features migrated to Riverpod.
void setupLegacyGetXDependencies() {
  Get.put<NetworkController>(NetworkController(), permanent: true);
  Get.lazyPut(() => TabViewController());
  Get.lazyPut(() => ExploreStoryController());
}
