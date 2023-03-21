import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:resonate/pages/login.dart';

class ProfilePage extends StatelessWidget {

  final UserProfile? user;

  const ProfilePage(this.user, {final Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(user?.pictureUrl.toString() ?? ''),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Name: ${user?.name}'),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
