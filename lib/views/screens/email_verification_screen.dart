import 'dart:ui';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({Key? key}) : super(key: key);

  final controller = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Obx(
        () => Stack(children: [
          !controller.authStateController.isInitializing.value
              ? SingleChildScrollView(
                  child: Container(
                    color: AppColor.bgBlackColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Resonate",
                                style: TextStyle(
                                    color: Colors.amber, fontSize: 26),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Material(
                                  child: InkWell(
                                    onTap: () =>
                                        {Get.toNamed(AppRoutes.tabview)},
                                    child: Ink(
                                        height: 32,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          gradient: AppColor.gradientBg,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Back",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 40,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(161, 112, 106, 80),
                                  Color.fromARGB(232, 60, 58, 52)
                                ])),
                            child: const Center(
                                child: Text(
                              "OTP Verification",
                              style: TextStyle(fontSize: 20),
                            )),
                          ),
                        ),
                        const SizedBox(height: 90),
                        Stack(children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(255, 45, 42, 42),
                                          Color.fromARGB(255, 57, 53, 53),
                                        ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Enter the OTP sent to ${controller.authStateController.email}',
                                        textAlign: TextAlign.center),
                                    const SizedBox(height: 40),
                                    OtpTextField(
                                      numberOfFields: 6,
                                      focusedBorderColor: const Color.fromARGB(
                                          224, 68, 170, 50),
                                      enabledBorderColor: const Color.fromARGB(
                                          182, 255, 193, 7),
                                      showFieldAsBox: true,
                                      //runs when every textfield is filled
                                      onSubmit:
                                          (String verificationCode) async {
                                        controller.isVerifying.value = true;
                                        await controller
                                            .verifyOTP(verificationCode);
                                        if (controller.res_verify.response ==
                                            '{"message":"null"}') {
                                          String result = await controller
                                              .checkVerificationStatus();
                                          if (result == "true") {
                                            Get.snackbar(
                                                "Verification Complete",
                                                "Congratulations you have verified your Email");
                                            await controller.setVerified();
                                            if (controller.res_set_verified
                                                    .response ==
                                                '{"message":"null"}') {
                                              controller.isVerifying.value =
                                                  false;
                                              controller.authStateController
                                                  .setUserProfileData();
                                              Get.toNamed(AppRoutes.tabview);
                                            } else {
                                              controller.isVerifying.value =
                                                  false;
                                              Get.snackbar(
                                                  'Oops',
                                                  controller.res_set_verified
                                                      .response);
                                            }
                                          } else {
                                            controller.isVerifying.value =
                                                false;
                                            Get.snackbar("Verification Failed",
                                                "OTP mismatch occured please try again");
                                          }
                                        } else {
                                          Get.snackbar('Oops',
                                              controller.res_verify.response);
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 60),
                                    Obx(
                                      () => Container(
                                        width: 300,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    232, 235, 181, 19),
                                                width: 3),
                                            borderRadius:
                                                BorderRadius.circular(70),
                                            gradient: controller
                                                    .resendIsAllowed.value
                                                ? AppColor.gradientBg
                                                : const LinearGradient(colors: [
                                                    Color.fromARGB(
                                                        255, 74, 74, 74),
                                                    Color.fromARGB(
                                                        255, 68, 63, 63)
                                                  ])),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            70),
                                                    side: const BorderSide(
                                                        width: 0,
                                                        color: Colors
                                                            .transparent)),
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor:
                                                    Colors.transparent),
                                            onPressed:
                                                controller.resendIsAllowed.value
                                                    ? () {
                                                        controller
                                                            .resendIsAllowed
                                                            .value = false;
                                                        controller.sendOTP();
                                                        Get.snackbar(
                                                            "OTP Resent",
                                                            "Please do check your mail for a new OTP");
                                                      }
                                                    : () {
                                                        Get.snackbar("Hold on",
                                                            "Please wait till the timer completes");
                                                      },
                                            child: controller
                                                    .resendIsAllowed.value
                                                ? const Text(
                                                    "Resend OTP",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "Resend OTP?",
                                                      ),
                                                      const SizedBox(
                                                        width: 120,
                                                      ),
                                                      CircularCountDownTimer(
                                                        textStyle: const TextStyle(
                                                            fontSize: 12,
                                                            color: AppColor
                                                                .bgBlackColor),
                                                        isTimerTextShown: true,
                                                        isReverse: true,
                                                        onComplete: () => {
                                                          controller
                                                              .resendIsAllowed
                                                              .value = true
                                                        },
                                                        width: 35,
                                                        height: 35,
                                                        duration: 30,
                                                        backgroundColor:
                                                            Colors.amber,
                                                        fillColor: const Color
                                                                .fromARGB(
                                                            255, 74, 74, 74),
                                                        ringColor: const Color
                                                                .fromARGB(
                                                            255, 130, 130, 130),
                                                      ),
                                                    ],
                                                  )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                                onTap: () {
                                  controller.Pressed.value =
                                      !controller.Pressed.value;
                                  if (controller.Pressed.value == false) {
                                    controller.shouldDisplay.value = false;
                                  }
                                },
                                child: AnimatedContainer(
                                    onEnd: () {
                                      if (controller.Pressed.value == true) {
                                        controller.shouldDisplay.value = true;
                                      }
                                    },
                                    height: 35,
                                    width: controller.Pressed.value ? 180 : 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color.fromARGB(186, 255, 255, 255),
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                    child: controller.shouldDisplay.value
                                        ? const Center(
                                            child: Text(
                                              "Verify Your Email",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )
                                        : SizedBox())),
                          )
                        ]),
                      ],
                    ),
                  ),
                )
              : BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                          color: Colors.amber, size: Get.pixelRatio * 20)),
                ),
          controller.isVerifying.value
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                      child: LoadingAnimationWidget.threeRotatingDots(
                          color: Colors.amber, size: Get.pixelRatio * 20)),
                )
              : const SizedBox(),
        ]),
      ),
    ));
  }
}
