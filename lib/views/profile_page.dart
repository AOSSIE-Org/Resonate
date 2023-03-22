import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:resonate/constants/app_routes.dart';
import 'package:resonate/services/oauth_provider.dart';
import 'package:resonate/views/login_page.dart';

class ProfilePage extends StatefulWidget {
  final Credentials credentials;

  const ProfilePage({super.key, required this.credentials});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile get user => widget.credentials.user;
  String? get name => user.name;
  Uri? get photo => user.pictureUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: const SizedBox.shrink(),
      ),
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(photo.toString()),
              radius: 40,
            ),
            const SizedBox(height: 12),
            Text(
              name ?? 'No name',
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                AuthenticationWithSocialConnections authWithSocials =
                    AuthenticationWithSocialConnections();

                await authWithSocials.signOut();
                navigateToLoginPage();
              },
              child: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }

  void navigateToLoginPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
  }
}
