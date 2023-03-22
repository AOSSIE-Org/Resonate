import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:resonate/services/google_sign_in.dart';
import 'package:resonate/views/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () async {
                try {
                  SignInWithGoogle signInWithGoogle = SignInWithGoogle();
                  final credentials = await signInWithGoogle.signIn();
                  navigateToUserProfile(credentials);
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void navigateToUserProfile(Credentials credentials) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          credentials: credentials,
        ),
      ),
    );
  }
}
