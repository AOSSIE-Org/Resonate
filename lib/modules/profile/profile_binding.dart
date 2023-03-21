import 'package:get/get.dart';
import 'package:resonate/modules/profile/profile_controller.dart';

class ProfileBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => ProfileController());
  }
}