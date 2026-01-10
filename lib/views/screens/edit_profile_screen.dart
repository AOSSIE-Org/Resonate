import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/debouncer.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';
import 'package:resonate/views/widgets/snackbar.dart';
import 'package:resonate/l10n/app_localizations.dart';

import '../../controllers/auth_state_controller.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../routes/app_routes.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  // Initializing controllers
  final EditProfileController editProfileController = Get.put(
    EditProfileController(),
  );
  final AuthStateController authStateController = Get.put(
    AuthStateController(),
  );
  final debouncer = Debouncer(milliseconds: 800);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          !(editProfileController.isLoading.value ||
              editProfileController.isThereUnsavedChanges()),
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

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
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.editProfile)),
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
                    SizedBox(height: UiSizes.height_20),
                    GetBuilder<ThemeController>(
                      builder: (themeController) => CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        backgroundImage: (controller.profileImagePath == null)
                            ? authStateController.profileImageUrl == "" ||
                                      controller.removeImage
                                  ? NetworkImage(
                                      themeController
                                          .userProfileImagePlaceholderUrl,
                                    )
                                  : NetworkImage(
                                      authStateController.profileImageUrl!,
                                    )
                            : FileImage(File(controller.profileImagePath!))
                                  as ImageProvider,
                        radius: UiSizes.width_80,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Semantics(
                            label: AppLocalizations.of(
                              context,
                            )!.uploadProfilePicture,
                            child: GestureDetector(
                              onTap: () {
                                showBottomSheet();
                              },
                              child: CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                child: Icon(
                                  Icons.edit,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_40),
                    TextFormField(
                      validator: (value) => value!.isNotEmpty
                          ? null
                          : AppLocalizations.of(context)!.requiredField,
                      controller: controller.nameController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.name,
                        prefixIcon: Icon(Icons.abc_rounded),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_20),
                    Obx(
                      () => TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 36,
                        validator: (value) {
                          if (value!.length >= 7) {
                            final validUsername = RegExp(
                              r'^[a-zA-Z0-9._-]+$',
                            ).hasMatch(value.trim());
                            if (!validUsername) {
                              return AppLocalizations.of(
                                context,
                              )!.usernameInvalidFormat;
                            }
                            return null;
                          } else {
                            return AppLocalizations.of(
                              context,
                            )!.usernameCharacterLimit;
                          }
                        },
                        controller: controller.usernameController,
                        onChanged: (value) {
                          Get.closeCurrentSnackbar();

                          final trimmedValue = value.trim();

                          if (trimmedValue == authStateController.userName) {
                            controller.usernameAvailable.value = true;
                            controller.usernameChecking.value = false;
                            return;
                          }

                          if (trimmedValue.length < 7) {
                            controller.usernameAvailable.value = false;
                            controller.usernameChecking.value = false;
                            return;
                          }

                          if (!RegExp(
                            r'^[a-zA-Z0-9._-]+$',
                          ).hasMatch(trimmedValue)) {
                            controller.usernameAvailable.value = false;
                            controller.usernameChecking.value = false;
                            return;
                          }

                          controller.usernameChecking.value = true;
                          controller.usernameAvailable.value = false;

                          debouncer.run(() async {
                            final available = await controller
                                .isUsernameAvailable(value.trim());

                            controller.usernameChecking.value = false;
                            controller.usernameAvailable.value = available;

                            if (!available) {
                              customSnackbar(
                                AppLocalizations.of(
                                  context,
                                )!.usernameUnavailable,
                                AppLocalizations.of(
                                  context,
                                )!.usernameAlreadyTaken,
                                LogType.error,
                                snackbarDuration: 1,
                              );
                            }
                          });
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.username,
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: controller.usernameChecking.value
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : controller.usernameAvailable.value
                              ? const Icon(
                                  Icons.verified_outlined,
                                  color: Colors.green,
                                )
                              : (controller.usernameController.text
                                            .trim()
                                            .length >=
                                        7 &&
                                    RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(
                                      controller.usernameController.text.trim(),
                                    ))
                              ? const Icon(Icons.close, color: Colors.red)
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.changeEmail),
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
                          onPressed:
                              (!controller.isLoading.value &&
                                  controller.usernameAvailable.value)
                              ? () async {
                                  await controller.saveProfile();
                                }
                              : null,
                          child: controller.isLoading.value
                              ? Center(
                                  child:
                                      LoadingAnimationWidget.horizontalRotatingDots(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        size: UiSizes.size_40,
                                      ),
                                )
                              : Text(AppLocalizations.of(context)!.saveChanges),
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
      title: AppLocalizations.of(context)!.saveChanges,
      titleStyle: const TextStyle(fontWeight: FontWeight.w500),
      titlePadding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
      content: Text(
        textAlign: TextAlign.center,
        AppLocalizations.of(context)!.unsavedChangesWarning,
        style: TextStyle(fontSize: UiSizes.size_14),
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
                child: Text(
                  AppLocalizations.of(context)!.discard,
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
                  AppLocalizations.of(context)!.save,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
          AppLocalizations.of(context)!.changeProfilePicture,
          style: TextStyle(
            fontSize: UiSizes.size_20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: UiSizes.height_30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  tooltip: AppLocalizations.of(context)!.clickPictureCamera,
                  onPressed: () {
                    Navigator.pop(context);
                    loadingDialog(context);
                    editProfileController.pickImageFromCamera();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconSize: UiSizes.size_56,
                ),
                Text(AppLocalizations.of(context)!.camera),
              ],
            ),
            Column(
              children: [
                IconButton(
                  tooltip: AppLocalizations.of(context)!.pickImageGallery,
                  onPressed: () {
                    Navigator.pop(context);
                    loadingDialog(context);
                    editProfileController.pickImageFromGallery();
                  },
                  icon: Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconSize: UiSizes.size_56,
                ),
                Text(AppLocalizations.of(context)!.gallery),
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
                  Text(AppLocalizations.of(context)!.remove),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
