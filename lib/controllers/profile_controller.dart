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

  bool isLoading = false;
  ResonateUser? resonateUser;


  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection("users").doc(auth.currentUser?.uid).get();
    if(doc.exists){
      resonateUser = ResonateUser.fromJson(doc.data()!);
    }
    //TODO: Get user data and update variables
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
