import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/profile_controller.dart';

import '../widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({final Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: Get.height*0.06,),
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
                "@ ${controller.resonateUser!.userName}",
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
