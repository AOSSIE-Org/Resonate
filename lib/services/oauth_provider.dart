import 'dart:developer';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resonate/services/auth_service.dart';

enum SocialConnection {
  google('google-oauth2');

  final String getName;

  const SocialConnection(this.getName);
}

class AuthenticationWithSocialConnections
    extends AuthenticationService<Credentials> {
  SocialConnection get connection {
    throw UnimplementedError('connection getter must be implemented');
  }

  @override
  Future<Credentials> signIn() async {
    try {
      Credentials response =
          await auth0.webAuthentication(scheme: 'demo').login(
        parameters: {'connection': connection.getName},
      );
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // // Obtain the auth details from the request
      // final GoogleSignInAuthentication? googleAuth =
      //     await googleUser?.authentication;

      // if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      //   // Create a new credential
      //   // final credential = GoogleAuthProvider.credential(
      //   //   accessToken: googleAuth?.accessToken,
      //   //   idToken: googleAuth?.idToken,
      //   // );
      //   log(googleAuth.toString());
      // }
      if (kDebugMode) {
        print(response.accessToken);
      }
      return response;
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e.toString());
      }
      throw Exception();
    }
  }

  @override
  Future<void> signOut() async {
    await auth0.webAuthentication(scheme: 'demo').logout();
  }
}
