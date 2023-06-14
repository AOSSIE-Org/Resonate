import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resonate/models/resonate_user.dart';

import '../routes/app_routes.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  RxBool isLoading = false.obs;
  ResonateUser? resonateUser;


  @override
  void onInit() async {
    super.onInit();
    await getUserData();
  }

  Future<void> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection("users").doc(auth.currentUser?.uid).get();
    var userData = doc.data()!;
    userData["uid"] = auth.currentUser!.uid;
    resonateUser = ResonateUser.fromJson(userData);
    update();
  }

  Future<void> logout() async {
    User? firebaseUser = auth.currentUser;
    if ((firebaseUser?.providerData[0].providerId == "google.com")) {
      await _googleSignIn.signOut();
      await auth.signOut();
    } else {
      await auth.signOut();
    }
    Get.offNamed(AppRoutes.login);
  }

}
