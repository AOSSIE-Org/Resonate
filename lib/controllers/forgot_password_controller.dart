import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../services/appwrite_service.dart';

class ForgotPasswordController extends GetxController {
  final Account account = AppwriteService.getAccount();

  final emailController = TextEditingController();

  final forgotPasswordFormKey = GlobalKey<FormState>();

  Future<bool> sendRecoveryEmail() async {
    try {
      await account.createRecovery(email: emailController.text, url: "*");
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
