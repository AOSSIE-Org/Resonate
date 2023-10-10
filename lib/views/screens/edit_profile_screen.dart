import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/edit_profile_controller.dart';

import '../../utils/ui_sizes.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  Widget verticalGap(double height) {
    return SizedBox(
      height: height,
    );
  }

  final InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.amber,
        width: UiSizes.width_2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  );

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

        return editProfileController.isLoading.value
            ? Future<bool>.value(false)
            : Future<bool>.value(true);
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

            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_45),

            child: Form(
              key: controller.editProfileFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalGap(UiSizes.height_60),
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
                    verticalGap(UiSizes.height_60),

                    TextFormField(
                      controller: controller.nameController,
                      validator: (value) =>
                          value!.isNotEmpty ? null : 'Required field',
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      cursorRadius: const Radius.circular(10),
                      decoration: inputDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                        labelText: "Full Name",
                      ),
                    ),

                    verticalGap(UiSizes.height_20),

                    Obx(
                      () => TextFormField(
                        controller: controller.usernameController,
                        cursorRadius: const Radius.circular(10),
                        validator: (value) {
                          if (value!.length > 5) {
                            return null;
                          } else {
                            return "Username must contain more than 5 characters.";
                          }
                        },
                        onChanged: (value) async {
                          if (value.length > 5) {
                            controller.usernameAvailable.value =
                                await controller.isUsernameAvailable(value);
                          } else {
                            controller.usernameAvailable.value = false;
                          }
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        decoration: inputDecoration.copyWith(
                            prefixIcon: const Icon(
                              Icons.account_circle,
                            ),
                            labelText: "Username",
                            prefixText: "@",
                            suffixIcon: controller.usernameAvailable.value
                                ? const Icon(
                                    Icons.verified_outlined,
                                    color: Colors.green,
                                  )
                                : null),
                      ),
                    ),

                    verticalGap(UiSizes.height_60),
                    Obx(
                      () => ElevatedButton(
                        onPressed: () {
                          if (!controller.isLoading.value) {
                            controller.saveProfile();
                          }
                        },
                        child: controller.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  color: Colors.black,
                                  size: UiSizes.size_40,
                                ),
                              )
                            : const Text(
                                'Save changes',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     if(controller.profileImagePath != null){
                    //       controller.saveProfile();
                    //     }
                    //   },
                    //   child: const Text('Save changes', style: TextStyle(fontSize: 18),),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
