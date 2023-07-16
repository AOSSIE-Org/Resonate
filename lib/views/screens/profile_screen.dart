import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/utils/colors.dart';

import '../widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({final Key? key}) : super(key: key);
  var authController = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthStateController>(
      builder: (controller) => Scaffold(
        body: Obx(
          () => Center(
              child: Stack(children: [
            controller.isInitializing.value
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.amber, size: Get.pixelRatio * 20)),
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(
                        height: Get.height * 0.06,
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber, width: 4),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image:
                                NetworkImage(controller.profileImageUrl ?? ''),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  controller.isPressed.value =
                                      !(controller.isPressed.value);
                                  if (controller.isPressed.value == false) {
                                    controller.shouldDisplay.value = false;
                                  }
                                },
                                child: AnimatedContainer(
                                    onEnd: () {
                                      if (controller.isPressed.value == true) {
                                        controller.shouldDisplay.value = true;
                                      }
                                    },
                                    width:
                                        controller.isPressed.value ? 140 : 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    duration: const Duration(milliseconds: 300),
                                    child: controller.isEmailVerified!
                                        ? Row(
                                            children: [
                                              const Icon(
                                                Icons.verified_rounded,
                                                color: AppColor.greenColor,
                                                size: 29,
                                              ),
                                              controller.shouldDisplay.value
                                                  ? const SizedBox(
                                                      width: 5,
                                                    )
                                                  : const SizedBox(),
                                              controller.shouldDisplay.value
                                                  ? const Text(
                                                      "Email Verified",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              const Icon(
                                                Icons.cancel_rounded,
                                                color: Color.fromARGB(
                                                    255, 236, 53, 40),
                                                size: 29,
                                              ),
                                              controller.shouldDisplay.value
                                                  ? const SizedBox(
                                                      width: 5,
                                                    )
                                                  : const SizedBox(),
                                              controller.shouldDisplay.value
                                                  ? const Text(
                                                      "Verify Email",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "@ ${controller.userName}",
                        style:
                            const TextStyle(fontSize: 35, color: Colors.amber),
                      ),
                      Text(
                        controller.displayName.toString(),
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        controller.email.toString(),
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                      const SizedBox(height: 14),
                      !(controller.isEmailVerified!)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Material(
                                child: InkWell(
                                  highlightColor:
                                      Color.fromARGB(138, 33, 140, 14),
                                  splashColor: Color.fromARGB(172, 43, 174, 20),
                                  onTap: () => {
                                    controller.isSending.value = true,
                                    authController.sendOTP()
                                  },
                                  child: Ink(
                                      height: 40,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(235, 111, 88, 5),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.amber, width: 3)),
                                      child: const Center(
                                        child: Text("Verify Email"),
                                      )),
                                ),
                              ),
                            )
                          : SizedBox(),
                      const SizedBox(height: 8),
                      CustomCard(
                        title: "Contribute to the project",
                        icon: FontAwesomeIcons.github,
                        onTap: () {
                          //TODO: Open Github Repo Link
                        },
                      ),
                      CustomCard(
                        title: "Terms and Conditions",
                        icon: FontAwesomeIcons.fileInvoice,
                        onTap: () {
                          //TODO: Launch URL in webview
                        },
                      ),
                      CustomCard(
                        title: "Privacy Policy",
                        icon: FontAwesomeIcons.shieldHalved,
                        onTap: () {
                          //TODO: Launch URL in webview
                        },
                      ),
                    ],
                  ),
            controller.isSending.value
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.amber, size: Get.pixelRatio * 20)),
                  )
                : SizedBox(),
          ])),
        ),
      ),
    );
  }
}
