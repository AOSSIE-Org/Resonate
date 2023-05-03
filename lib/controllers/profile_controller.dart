import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class ProfileController extends GetxController{
  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
  }
}