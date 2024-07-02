import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/onboarding_controller.dart';
import '../../utils/ui_sizes.dart';

class NewOnBoardingScreen extends StatelessWidget {
  const NewOnBoardingScreen({super.key});

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
            horizontal: UiSizes.width_30,
          ),
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Form(
              key: controller.userOnboardingFormKey,

              child: Column(
                children: [
                  SizedBox(height: UiSizes.height_40),
                  Text(
                    "Complete your Profile",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: UiSizes.height_60),
                  GestureDetector(
                    onTap: () async => await controller.pickImage(),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      backgroundImage: (controller.profileImagePath == null)
                          ? NetworkImage(controller.imageController.text)
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
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: UiSizes.size_20,
                              ),
                            ),
                          ),
                        ],
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
                      hintText: "Name",
                      // labelText: "Name",
                      prefixIcon: Icon(Icons.abc_rounded),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_10),
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
                        if (value.length > 5) {
                          controller.usernameAvailable.value = await controller
                              .isUsernameAvailable(value.trim());
                        } else {
                          controller.usernameAvailable.value = false;
                        }
                      },
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: "Username",
                        // labelText: "Username",
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
                  SizedBox(height: UiSizes.height_10),
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
                      // labelText: "Date of Birth",
                      hintText: "Date of Birth",
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
                                child:
                                    LoadingAnimationWidget.horizontalRotatingDots(
                                  color: Theme.of(context).colorScheme.onPrimary,
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
    );
  }
}
