import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/edit_profile_controller.dart';

import '../../utils/constants.dart';
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

  // Initializing controllers
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  final AuthStateController authStateController =
      Get.put(AuthStateController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (editProfileController.isLoading.value) {
          return false;
        } else {
          if (editProfileController.isThereUnsavedChanges()) {
            saveChangesDialogue();
          }
          return true;
        }
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
                          ? controller.removeImage
                              ? const NetworkImage(
                                  userProfileImagePlaceholderUrl)
                              : NetworkImage(
                                  authStateController.profileImageUrl!)
                          : FileImage(File(controller.profileImagePath!))
                              as ImageProvider,
                      radius: UiSizes.size_70,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            showBottomSheet();
                          },
                          // onTap: () async => await controller.pickImage(),
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
                        onPressed: () async {
                          if (!controller.isLoading.value) {
                            await controller.saveProfile();
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return changeProfilePictureBottomSheet(Get.context!);
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    );
  }

  void saveChangesDialogue() {
    Get.defaultDialog(
      title: 'Save changes',
      titleStyle: const TextStyle(fontWeight: FontWeight.w500),
      titlePadding: const EdgeInsets.symmetric(vertical: 20),
      content: Text(
        "If you proceed without saving, any unsaved changes will be lost.",
        style: TextStyle(
          color: Colors.grey,
          fontSize: UiSizes.size_14,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Navigator.pop(Get.context!);
                },
                child: const Text(
                  'Discard',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await editProfileController.saveProfile();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget changeProfilePictureBottomSheet(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding:
          EdgeInsets.only(top: UiSizes.height_30, bottom: UiSizes.height_56),
      children: [
        Text(
          'Change profile picture',
          style:
              TextStyle(fontSize: UiSizes.size_20, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: UiSizes.height_30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    editProfileController.pickImageFromCamera();
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                  ),
                  iconSize: UiSizes.size_56,
                ),
                const Text('Camera')
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    editProfileController.pickImageFromGallery();
                  },
                  icon: const Icon(
                    Icons.image,
                  ),
                  iconSize: UiSizes.size_56,
                ),
                const Text('Gallery')
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    editProfileController.removeProfilePicture();
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                  iconSize: UiSizes.size_56,
                ),
                const Text('Remove')
              ],
            ),
          ],
        ),
      ],
    );
  }
}
