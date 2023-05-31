import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';

class AuthenticationBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AuthenticationController());
  }
}