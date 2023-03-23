import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resonate/main.dart';
import 'package:resonate/services/auth/google_signin.dart';

class ProfileScreen extends StatelessWidget {
  final GoogleSignInAccount user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl!),
              radius: 50,
            ),
            Text(
              user.displayName!,
              style: TextStyle(fontSize: 25),
            ),
            Text(
              user.email!,
              style: TextStyle(fontSize: 15),
            ),
            ElevatedButton(
                onPressed: () {
                  GoogleSignInApi.logout();
                  Get.to(LoginScreen());
                },
                child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
