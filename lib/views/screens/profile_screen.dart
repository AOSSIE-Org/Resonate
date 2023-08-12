import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../utils/constants.dart';
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
                          width: UiSizes.width_200,
                          height: UiSizes.height_200,
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
                                              ? UiSizes.width_190
                                              : UiSizes.width_40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
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
                                                  size: UiSizes.size_40,
                                                ),
                                                emailVerifyController
                                                        .shouldDisplay.value
                                                    ? SizedBox(
                                                        width: UiSizes.width_20,
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
                                                  size: UiSizes.size_40,
                                                ),
                                                emailVerifyController
                                                        .shouldDisplay.value
                                                    ? SizedBox(
                                                        width: UiSizes.width_20,
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
                            ),),),
                            SizedBox(height: 0.017 * Get.height),
                            !(controller.isEmailVerified!)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Material(
                                      child: InkWell(
                                        highlightColor: const Color.fromARGB(
                                            138, 33, 140, 14),
                                        splashColor: const Color.fromARGB(
                                            172, 43, 174, 20),
                                        onTap: () => {
                                          // controller.isSending.value = true,
                                          // authController.sendOTP()
                                        },
                                        child: Ink(
                                            height: 0.048 * Get.height,
                                            width: 0.34 * Get.width,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    235, 111, 88, 5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.amber,
                                                    width: 3)),
                                            child: const Center(
                                              child: Text("Verify Email"),
                                            )),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(height: 0.0097 * Get.height),
                            CustomCard(
                              title: "Contribute to the project",
                              icon: FontAwesomeIcons.github,
                              onTap: () {
                                Uri url = Uri.parse(githubRepoUrl);
                                try{
                                  launchUrl(url);
                                }catch(e){
                                  log("Error launching URL: ${e.toString()}");
                                }
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
                            CustomCard(
                              title: "Logout",
                              icon: Icons.exit_to_app_outlined,
                              onTap: () async {
                                await authStateController.logout();
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
