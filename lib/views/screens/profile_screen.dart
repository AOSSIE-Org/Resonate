import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({final Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 4),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        controller.auth.currentUser?.photoURL.toString() ?? ''),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "@ ${controller.resonateUser!.userName!}",
                style: TextStyle(fontSize: 35, color: Colors.amber),
              ),
              Text(
                controller.auth.currentUser!.displayName.toString(),
                style: TextStyle(fontSize: 25),
              ),
              Text(
                controller.auth.currentUser!.email.toString(),
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              CustomCard(
                title: "Contribute to the project",
                icon: FontAwesomeIcons.github,
                onTap: () {
                  //TODO: Open Github Repo Link
                },
              ),
              CustomCard(
                title: "Terms and Conditions",
                icon: FontAwesomeIcons.fileInvoice,
                onTap: () {
                  //TODO: Launch URL in webview
                },
              ),
              CustomCard(
                title: "Privacy Policy",
                icon: FontAwesomeIcons.shieldHalved,
                onTap: () {
                  //TODO: Launch URL in webview
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  CustomCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: FaIcon(icon),
          title: Text(title),
        ),
      ),
    );
  }
}
