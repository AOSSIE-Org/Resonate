import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: UiSizes.height_740,
              width: Get.width,
              padding: EdgeInsets.symmetric(
                  horizontal: UiSizes.width_20, vertical: UiSizes.height_10),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.userOnboardingFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: UiSizes.heigth_33),
                      Text(
                        "Complete your Profile",
                        style: TextStyle(fontSize: UiSizes.size_28),
                      ),
                      SizedBox(height: UiSizes.heigth_33),
                      GestureDetector(
                        onTap: () async => await controller.pickImage(),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: (controller.profileImagePath == null)
                              ? NetworkImage(controller.imageController.text)
                              : FileImage(File(controller.profileImagePath!))
                                  as ImageProvider,
                          radius: UiSizes.size_70,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: UiSizes.size_15,
                                  backgroundColor: Colors.yellow,
                                  // TO CONTINUE`
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: UiSizes.size_20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: UiSizes.height_30),
                      SizedBox(
                        height: UiSizes.height_66,
                        child: TextFormField(
                          cursorRadius: const Radius.circular(10),
                          style: TextStyle(fontSize: UiSizes.size_14),
                          validator: (value) =>
                              value!.isNotEmpty ? null : "Enter Valid Name",
                          controller: controller.nameController,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                size: UiSizes.size_23,
                              ),
                              errorStyle: TextStyle(fontSize: UiSizes.size_14),
                              labelText: "Full Name",
                              labelStyle: TextStyle(fontSize: UiSizes.size_14)),
                        ),
                      ),
                      SizedBox(height: UiSizes.height_24_6),
                      SizedBox(
                        height: UiSizes.height_70,
                        child: Obx(
                          () => TextFormField(
                            cursorRadius: const Radius.circular(10),
                            style: TextStyle(fontSize: UiSizes.height_14),
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
                                controller.usernameAvailable.value =
                                    await controller.isUsernameAvailable(value);
                              } else {
                                controller.usernameAvailable.value = false;
                              }
                            },
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                            decoration: InputDecoration(
                                floatingLabelStyle: TextStyle(
                                    fontSize: UiSizes.height_14,
                                    color: AppColor.yellowColor),
                                prefixStyle:
                                    TextStyle(fontSize: UiSizes.height_14),
                                errorStyle:
                                    TextStyle(fontSize: UiSizes.height_14),
                                icon: Icon(
                                  Icons.account_circle,
                                  size: UiSizes.size_23,
                                ),
                                labelText: "Username",
                                prefixText: "@",
                                labelStyle:
                                    TextStyle(fontSize: UiSizes.size_13),
                                suffixIcon: controller.usernameAvailable.value
                                    ? Icon(
                                        Icons.verified_outlined,
                                        size: UiSizes.size_23,
                                      )
                                    : null),
                          ),
                        ),
                      ),
                      SizedBox(height: UiSizes.height_24_6),
                      SizedBox(
                        height: UiSizes.height_66,
                        child: TextFormField(
                          style: TextStyle(fontSize: UiSizes.size_14),
                          validator: (value) =>
                              value!.isNotEmpty ? null : "Enter Valid DOB",
                          readOnly: true,
                          controller: controller.dobController,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.calendar_month,
                              size: UiSizes.size_23,
                            ),
                            labelText: "Date of Birth",
                            labelStyle: TextStyle(fontSize: UiSizes.size_14),
                            suffix: GestureDetector(
                              onTap: () async {
                                await controller.chooseDate();
                              },
                              child: const Icon(Icons.date_range),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: UiSizes.height_66),
                      SizedBox(
                        height: UiSizes.height_55,
                      ),
                      Obx(() {
                        return ElevatedButton(
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
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: UiSizes.size_21_3,
                                  ),
                                ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
