import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';

class AuthenticationBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AuthStateContoller());
    Get.lazyPut(() => AuthenticationController());
  }
}