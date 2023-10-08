import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/edit_profile_controller.dart';

import '../../utils/ui_sizes.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});



  @override
  Widget build(BuildContext context) {

    // Initializing controllers
    final EditProfileController editProfileController =
    Get.put(EditProfileController());
    final AuthStateController authStateController =
    Get.put(AuthStateController());


    return WillPopScope(
      onWillPop: () async {

        editProfileController.profileImagePath = null;

        return Future<bool>.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: GetBuilder<EditProfileController>(
          builder: (controller) => Container(
            // color: Colors.red,

            height: double.maxFinite,
            width: double.maxFinite,

            padding: EdgeInsets.symmetric(vertical: UiSizes.height_45, horizontal: UiSizes.width_45),

            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: (controller.profileImagePath == null)
                      ? NetworkImage(authStateController.profileImageUrl!)
                      : FileImage(File(controller.profileImagePath!))
                          as ImageProvider,
                  radius: UiSizes.size_70,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () async => await controller.pickImage(),
                      child: const CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: UiSizes.height_60,
                ),
                ElevatedButton(
                  onPressed: () {
                    if(controller.profileImagePath != null){
                      controller.saveProfile();
                    }
                  },
                  child: const Text('Save changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
