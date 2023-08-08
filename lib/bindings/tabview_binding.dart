import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';

import '../controllers/auth_state_controller.dart';
import '../controllers/tabview_controller.dart';

class TabViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabViewController());
    Get.lazyPut(() => AuthStateController());
    Get.lazyPut(() => AuthenticationController());
    Get.lazyPut(() => RoomsController());
  }
}
