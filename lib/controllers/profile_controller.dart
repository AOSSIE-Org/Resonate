import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:resonate/models/resonate_user.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  final User? user = FirebaseAuth.instance.currentUser;
  ResonateUser? resonateUser;


  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection("users").doc(user?.uid).get();
    if(doc.exists){
      resonateUser = ResonateUser.fromJson(doc.data()!);
    }

    //TODO: Get user data and update variables
    update();
  }

}
