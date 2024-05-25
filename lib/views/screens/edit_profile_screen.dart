import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/edit_profile_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/utils.dart';

import '../../utils/constants.dart';
import '../../utils/ui_sizes.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final ThemeController themeController = Get.find<ThemeController>();

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
        color: Get.find<ThemeController>().primaryColor.value,
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
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (editProfileController.isThereUnsavedChanges()) {
          AppUtils.saveChangesDialogue(
            onSaved: () async {
              Get.back();
              await editProfileController.saveProfile();
            },
          );
        } else {
          Navigator.pop(context);
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
                          child: CircleAvatar(
                            backgroundColor: themeController.primaryColor.value,
                            child: const Icon(
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
                              : null,
                          errorStyle: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    verticalGap(UiSizes.height_20),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.changeEmail);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Change Email',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: themeController.primaryColor.value),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: themeController.primaryColor.value,
                            )
                          ],
                        ),
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
                    verticalGap(UiSizes.height_20),
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
            if (authStateController.profileImageUrl !=
                userProfileImagePlaceholderUrl)
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
