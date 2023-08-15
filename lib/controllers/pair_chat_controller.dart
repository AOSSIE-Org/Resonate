import 'dart:developer';

import 'package:get/get.dart';

class PairChatController extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isAnonymous = true.obs;
  String languageIso = "en";

  void quickMatch(){
    log("isAnonymous: ${isAnonymous.value}");
    log("languageIso: $languageIso");
  }
}