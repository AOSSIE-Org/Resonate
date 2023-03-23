

import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInApi{

  static Future login() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      var user = await googleSignIn.signIn();
      return user;
    } catch (error) {
      print(error);
    }
  }

  static void logout() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

}
