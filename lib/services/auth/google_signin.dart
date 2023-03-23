import 'dart:io' show Platform;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static String _clientId =
      "375993303437-tsvpf8s7gbs653429utb1p1hgpto4gbv.apps.googleusercontent.com";
  static GoogleSignIn _googleSignIn =
      (Platform.isAndroid) ? GoogleSignIn() : GoogleSignIn(clientId: _clientId);

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
