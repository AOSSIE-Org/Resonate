import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';

class CreateStoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExploreStoryController());
  }
}
