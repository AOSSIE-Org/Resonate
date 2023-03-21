import 'package:get/get.dart';
import 'package:resonate/modules/authentication/authentication_controller.dart';

class AuthenticationBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AuthenticationController());
  }
}