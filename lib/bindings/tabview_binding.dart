import 'package:get/get.dart';

import '../controllers/auth_state_controller.dart';
import '../controllers/tabview_controller.dart';


class TabViewBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => TabViewController());
    Get.lazyPut(() => AuthStateContoller());
  }
}