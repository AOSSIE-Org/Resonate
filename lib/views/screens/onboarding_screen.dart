import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/enums/gender.dart';

import '../../controllers/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: Get.height * 0.9,
              width: Get.width,
              padding: EdgeInsets.symmetric(
                  horizontal: 0.0486 * Get.width, vertical: 0.012 * Get.height),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.userOnboardingFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 0.04 * Get.height),
                      Text(
                        "Complete your Profile",
                        style: TextStyle(
                            fontSize: 0.017 * Get.height + 0.034 * Get.width),
                      ),
                      SizedBox(height: 0.04 * Get.height),
                      GestureDetector(
                        onTap: () async => await controller.pickImage(),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: (controller.profileImagePath == null)
                              ? NetworkImage(controller.imageController.text)
                              : FileImage(File(controller.profileImagePath!))
                                  as ImageProvider,
                          radius: 0.0395 * Get.height + 0.0789 * Get.width,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 0.009127 * Get.height +
                                      0.01823 * Get.width,
                                  backgroundColor: Colors.yellow,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 0.0121 * Get.height +
                                        0.0243 * Get.width,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 0.03 * Get.height),
                      SizedBox(
                        height: 0.07995 * Get.height,
                        child: TextFormField(
                          cursorRadius: Radius.circular(10),
                          style: TextStyle(
                              fontSize:
                                  0.0085 * Get.height + 0.017 * Get.width),
                          validator: (value) =>
                              value!.isNotEmpty ? null : "Enter Valid Name",
                          controller: controller.nameController,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                size: 0.014 * Get.height + 0.029 * Get.width,
                              ),
                              errorStyle: TextStyle(
                                  fontSize:
                                      0.0085 * Get.height + 0.017 * Get.width),
                              labelText: "Full Name",
                              labelStyle: TextStyle(
                                  fontSize:
                                      0.0085 * Get.height + 0.017 * Get.width)),
                        ),
                      ),
                      SizedBox(height: 0.03 * Get.height),
                      SizedBox(
                        height: 0.085 * Get.height,
                        child: Obx(
                          () => TextFormField(
                            cursorRadius: Radius.circular(10),
                            style: TextStyle(
                                fontSize:
                                    0.0085 * Get.height + 0.017 * Get.width),
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
                                    fontSize:
                                        0.0085 * Get.height + 0.017 * Get.width,
                                    color: AppColor.yellowColor),
                                prefixStyle: TextStyle(
                                    fontSize: 0.0085 * Get.height +
                                        0.017 * Get.width),
                                errorStyle: TextStyle(
                                    fontSize: 0.0085 * Get.height +
                                        0.017 * Get.width),
                                icon: Icon(
                                  Icons.account_circle,
                                  size: 0.014 * Get.height + 0.029 * Get.width,
                                ),
                                labelText: "Username",
                                prefixText: "@",
                                labelStyle: TextStyle(
                                    fontSize:
                                        0.008 * Get.height + 0.015 * Get.width),
                                suffixIcon: controller.usernameAvailable.value
                                    ? Icon(
                                        Icons.verified_outlined,
                                        size: 0.014 * Get.height +
                                            0.029 * Get.width,
                                      )
                                    : null),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.03 * Get.height),
                      SizedBox(
                        height: 0.07995 * Get.height,
                        child: TextFormField(
                          style: TextStyle(
                              fontSize:
                                  0.0085 * Get.height + 0.017 * Get.width),
                          validator: (value) =>
                              value!.isNotEmpty ? null : "Enter Valid DOB",
                          readOnly: true,
                          controller: controller.dobController,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.calendar_month,
                              size: 0.014 * Get.height + 0.029 * Get.width,
                            ),
                            labelText: "Date of Birth",
                            labelStyle: TextStyle(
                                fontSize:
                                    0.0085 * Get.height + 0.017 * Get.width),
                            suffix: GestureDetector(
                              onTap: () async {
                                await controller.chooseDate();
                              },
                              child: const Icon(Icons.date_range),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.08 * Get.height),
                      SizedBox(
                        height: 0.0669 * Get.height,
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
                                    size:
                                        0.024 * Get.height + 0.048 * Get.width,
                                  ),
                                )
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        0.013 * Get.height + 0.026 * Get.width,
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
