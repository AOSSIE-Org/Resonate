import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/email_verify_controller.dart';
import '../widgets/custom_card.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({final Key? key}) : super(key: key);

  final emailVerifyController = Get.find<EmailVerifyController>();

  AuthStateController authStateController =
      Get.put<AuthStateController>(AuthStateController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthStateController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            Row(
              children: [
                InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      await authStateController.logout();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 238, 49, 36)),
                          gradient: AppColor.gradientBg,
                          borderRadius: BorderRadius.circular(100)),
                      child: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              const Color.fromARGB(0, 255, 255, 255),
                          child: Icon(
                            Icons.logout_rounded,
                            color: Colors.black,
                          )),
                    )),
                SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
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
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: UiSizes.width_170,
                          height: UiSizes.height_170,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.amber, width: UiSizes.width_4),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  controller.profileImageUrl ?? ''),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    emailVerifyController.isExpanded.value =
                                        !(emailVerifyController
                                            .isExpanded.value);
                                    if (emailVerifyController
                                            .isExpanded.value ==
                                        false) {
                                      emailVerifyController
                                          .shouldDisplay.value = false;
                                    }
                                  },
                                  child: AnimatedContainer(
                                      onEnd: () {
                                        if (emailVerifyController
                                                .isExpanded.value ==
                                            true) {
                                          emailVerifyController
                                              .shouldDisplay.value = true;
                                        }
                                      },
                                      width:
                                          emailVerifyController.isExpanded.value
                                              ? UiSizes.width_160
                                              : UiSizes.width_35,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: controller.isEmailVerified!
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.verified_rounded,
                                                  color: AppColor.greenColor,
                                                  size: UiSizes.size_35,
                                                ),
                                                emailVerifyController
                                                        .shouldDisplay.value
                                                    ? SizedBox(
                                                        width: UiSizes.width_10,
                                                      )
                                                    : const SizedBox(),
                                                emailVerifyController
                                                        .shouldDisplay.value
                                                    ? Text(
                                                        "Email Verified",
                                                        style: TextStyle(
                                                            fontSize:
                                                                UiSizes.size_15,
                                                            color:
                                                                Colors.black),
                                                      )
                                                    : const SizedBox()
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  emailVerifyController
                                                          .isExpanded.value
                                                      ? MainAxisAlignment.start
                                                      : MainAxisAlignment
                                                          .center,
                                              children: [
                                                Icon(
                                                  Icons.cancel_rounded,
                                                  color: const Color.fromARGB(
                                                      255, 236, 53, 40),
                                                  size: UiSizes.size_35,
                                                ),
                                                emailVerifyController
                                                        .shouldDisplay.value
                                                    ? SizedBox(
                                                        width: UiSizes.width_10,
                                                      )
                                                    : const SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      ),
                                                emailVerifyController
                                                        .shouldDisplay.value
                                                    ? Text(
                                                        "Verify Email",
                                                        style: TextStyle(
                                                            fontSize:
                                                                UiSizes.size_15,
                                                            color:
                                                                Colors.black),
                                                      )
                                                    : const SizedBox(
                                                        height: 0,
                                                        width: 0,
                                                      )
                                              ],
                                            )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: UiSizes.height_20),
                        SizedBox(
                          width: UiSizes.width_320,
                          height: UiSizes.height_55,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "@ ${controller.userName}",
                              style: TextStyle(
                                  fontSize: UiSizes.size_35,
                                  color: Colors.amber),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: UiSizes.width_320,
                          height: UiSizes.height_40,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              controller.displayName.toString(),
                              style: TextStyle(fontSize: UiSizes.size_25),
                            ),
                          ),
                        ),
                        Text(
                          controller.email.toString(),
                          style: TextStyle(
                              fontSize: UiSizes.size_18, color: Colors.white70),
                        ),
                        SizedBox(height: UiSizes.height_20),
                        !(controller.isEmailVerified!)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Material(
                                  child: InkWell(
                                    highlightColor:
                                        const Color.fromARGB(138, 33, 140, 14),
                                    splashColor:
                                        const Color.fromARGB(172, 43, 174, 20),
                                    onTap: () => {
                                      emailVerifyController.isSending.value =
                                          true,
                                      emailVerifyController.sendOTP()
                                    },
                                    child: Ink(
                                        height: UiSizes.height_40,
                                        width: UiSizes.width_140,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                235, 111, 88, 5),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.amber, width: 3)),
                                        child: Center(
                                          child: Text(
                                            "Verify Email",
                                            style: TextStyle(
                                              fontSize: UiSizes.size_14,
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(height: UiSizes.height_30),
                        CustomCard(
                          title: "Contribute to the project",
                          icon: FontAwesomeIcons.github,
                          onTap: () {
                            //TODO: Open Github Repo Link
                          },
                        ),
                        SizedBox(
                          height: UiSizes.height_10,
                        ),
                        CustomCard(
                          title: "Terms and Conditions",
                          icon: FontAwesomeIcons.fileInvoice,
                          onTap: () {
                            //TODO: Launch URL in webview
                          },
                        ),
                        SizedBox(
                          height: UiSizes.height_10,
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
                  ),
            emailVerifyController.isSending.value
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.amber, size: Get.pixelRatio * 20)),
                  )
                : const SizedBox(),
          ])),
        ),
      ),
    );
  }
}
