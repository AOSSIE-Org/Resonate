import 'dart:io' show Platform;
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/constants.dart';

class GoogleSignInApi {
  static GoogleSignIn _googleSignIn =
      (Platform.isAndroid) ? GoogleSignIn() : GoogleSignIn(clientId: gcpClientId);

  static Future login() async {
    try {
      var user = await _googleSignIn.signIn();
      print(user?.displayName!);
      return user;
    } catch (error) {
      print(error);
    }
  }

  static void logout() async {
    await _googleSignIn.signOut();
  }
}
