import 'dart:developer';

import 'package:get/get.dart';
import 'package:resonate/routes/app_routes.dart';

class PairChatController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isAnonymous = true.obs;
  String languageIso = "en";

  void quickMatch(){
    log("isAnonymous: ${isAnonymous.value}");
    log("languageIso: $languageIso");
    Get.toNamed(AppRoutes.pairing);
  }
}