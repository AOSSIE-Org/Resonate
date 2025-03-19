import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/debouncer.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';

import '../../controllers/onboarding_controller.dart';
import '../../utils/ui_sizes.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final debouncer = Debouncer(milliseconds: 800);
  final themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: UiSizes.height_20,
            horizontal: UiSizes.width_20,
          ),
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Form(
              key: controller.userOnboardingFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: UiSizes.height_40),
                    Text(
                      "Complete your Profile",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: UiSizes.height_60),
                    Semantics(
                      label: "Upload profile picture",
                      child: GestureDetector(
                        onTap: () async => await controller.pickImage(),
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          backgroundImage: (controller.profileImagePath == null)
                              ? NetworkImage(
                                  themeController
                                      .userProfileImagePlaceholderUrl,
                                )
                              : FileImage(File(controller.profileImagePath!))
                                  as ImageProvider,
                          radius: UiSizes.width_80,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: UiSizes.width_20,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Icon(
                                    Icons.edit,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: UiSizes.size_20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_40),
                    TextFormField(
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter Valid Name",
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
                            return "Username should contain more than 5 characters.";
                          }
                        },
                        controller: controller.usernameController,
                        onChanged: (value) async {
                          Get.closeCurrentSnackbar();
                          if (value.length > 5) {
                            controller.usernameAvailableChecking.value = true;
                            debouncer.run(
                              () async {
                                controller.usernameAvailable.value =
                                    await controller.isUsernameAvailable(
                                  value.trim(),
                                );
                                controller.usernameAvailableChecking.value =
                                    false;
                                if (!controller.usernameAvailable.value) {
                                  customSnackbar(
                                    "Username Unavailable!",
                                    "This username is invalid or either taken already.",
                                    LogType.error,
                                    snackbarDuration: 1,
                                  );
                                }
                              },
                            );
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
                            suffixText:
                                controller.usernameAvailableChecking.value
                                    ? 'Checking...'
                                    : null,
                            suffixIcon: controller.usernameAvailable.value &&
                                    !controller.usernameAvailableChecking.value
                                ? const Icon(
                                    Icons.verified_outlined,
                                    color: Colors.green,
                                  )
                                : null),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_20),
                    TextFormField(
                      validator: (value) =>
                          value!.isNotEmpty ? null : "Enter Valid DOB",
                      readOnly: true,
                      onTap: () async {
                        await controller.chooseDate();
                      },
                      canRequestFocus: false,
                      controller: controller.dobController,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month_rounded),
                        labelText: "Date of Birth",
                        // hintText: "Date of Birth",
                      ),
                    ),
                    SizedBox(height: UiSizes.height_40),
                    SizedBox(
                      width: double.maxFinite,
                      child: Obx(
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: UiSizes.size_40,
                                  ),
                                )
                              : const Text('Submit'),
                        ),
                      ),
                    )
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
