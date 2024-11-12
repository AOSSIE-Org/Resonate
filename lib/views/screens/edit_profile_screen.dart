import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';

import '../../controllers/auth_state_controller.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../routes/app_routes.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  // Initializing controllers
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  final AuthStateController authStateController =
      Get.put(AuthStateController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !(editProfileController.isLoading.value ||
          editProfileController.isThereUnsavedChanges()),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        if (!editProfileController.isLoading.value &&
            editProfileController.isThereUnsavedChanges()) {
          await saveChangesDialogue(context);
        } else {
          if (!editProfileController.isLoading.value) {
            Get.back();
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: GetBuilder<EditProfileController>(
          builder: (controller) => Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              vertical: UiSizes.height_20,
              horizontal: UiSizes.width_20,
            ),
            child: Form(
              key: controller.editProfileFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: UiSizes.height_20,
                    ),
                    GetBuilder<ThemeController>(
                      builder: (themeController) => CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundImage: (controller.profileImagePath == null)
                            ? controller.removeImage
                                ? NetworkImage(
                                    themeController
                                        .userProfileImagePlaceholderUrl.value,
                                  )
                                : NetworkImage(
                                    authStateController.profileImageUrl!)
                            : FileImage(File(controller.profileImagePath!))
                                as ImageProvider,
                        radius: UiSizes.width_80,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Semantics(
                            label: "Upload profile picture",
                            child: GestureDetector(
                              onTap: () {
                                showBottomSheet();
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Icon(
                                  Icons.edit,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_40,
                    ),
                    TextFormField(
                      validator: (value) =>
                          value!.isNotEmpty ? null : 'Required field',
                      controller: controller.nameController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        // hintText: "Name",
                        labelText: "Name",
                        prefixIcon: Icon(Icons.abc_rounded),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_20),
                    Obx(
                      () => TextFormField(
                        validator: (value) {
                          if (value!.length > 5) {
                            return null;
                          } else {
                            return "Username must contain more than 5 characters.";
                          }
                        },
                        controller: controller.usernameController,
                        onChanged: (value) async {
                          if (value.length > 5) {
                            controller.usernameAvailable.value =
                                await controller
                                    .isUsernameAvailable(value.trim());
                          } else {
                            controller.usernameAvailable.value = false;
                          }
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        decoration: InputDecoration(
                          // hintText: "Username",
                          labelText: "Username",
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: controller.usernameAvailable.value
                              ? const Icon(
                                  Icons.verified_outlined,
                                  color: Colors.green,
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_20),
                    SizedBox(
                      width: double.maxFinite,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.changeEmail);
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size.fromHeight(UiSizes.height_60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Change Email'),
                            Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_60),
                    Obx(
                      () => SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!controller.isLoading.value) {
                              await controller.saveProfile();
                            }
                          },
                          child: controller.isLoading.value
                              ? Center(
                                  child: LoadingAnimationWidget
                                      .horizontalRotatingDots(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: UiSizes.size_40,
                                  ),
                                )
                              : const Text(
                                  'Save changes',
                                ),
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

  Future<void> saveChangesDialogue(BuildContext context) async {
    Get.defaultDialog(
      title: 'Save changes',
      titleStyle: const TextStyle(fontWeight: FontWeight.w500),
      titlePadding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
      content: Text(
        textAlign: TextAlign.center,
        "If you proceed without saving, any unsaved changes will be lost.",
        style: TextStyle(
          fontSize: UiSizes.size_14,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
      actions: [
        Padding(
          padding: EdgeInsets.only(bottom: UiSizes.height_5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text(
                  'DISCARD',
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await editProfileController.saveProfile();
                },
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    letterSpacing: 2,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
      padding: EdgeInsets.only(
        top: UiSizes.height_30,
        bottom: UiSizes.height_60,
      ),
      children: [
        Text(
          'Change profile picture',
          style: TextStyle(
            fontSize: UiSizes.size_20,
            fontWeight: FontWeight.w500,
          ),
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
                  tooltip: "Click picture using camera",
                  onPressed: () {
                    Navigator.pop(context);
                    // Display Loading Dialog
                    loadingDialog(context);
                    editProfileController.pickImageFromCamera();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconSize: UiSizes.size_56,
                ),
                const Text('Camera')
              ],
            ),
            Column(
              children: [
                IconButton(
                  tooltip: "Pick image from gallery",
                  onPressed: () {
                    Navigator.pop(context);

                    // Display Loading Dialog
                    loadingDialog(context);
                    editProfileController.pickImageFromGallery();
                  },
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconSize: UiSizes.size_56,
                ),
                const Text('Gallery')
              ],
            ),
            if (authStateController.profileImageUrl != null)
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      editProfileController.removeProfilePicture();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
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
