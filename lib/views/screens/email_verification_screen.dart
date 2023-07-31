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
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.048 * Get.width,
                        vertical: 0.012 * Get.height),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Resonate",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 10.4 * Get.pixelRatio),
                              ),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(5.714 * Get.height),
                                child: Material(
                                  child: InkWell(
                                    onTap: () =>
                                        {Get.toNamed(AppRoutes.tabview)},
                                    child: Ink(
                                        height: 0.038 * Get.height,
                                        width: 0.243 * Get.width,
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
                        SizedBox(height: 0.0973 * Get.height),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 0.0486 * Get.height,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(161, 112, 106, 80),
                                  Color.fromARGB(232, 60, 58, 52)
                                ])),
                            child: Center(
                                child: Text(
                              "OTP Verification",
                              style:
                                  TextStyle(fontSize: 5.714 * Get.pixelRatio),
                            )),
                          ),
                        ),
                        SizedBox(height: 0.1095 * Get.height),
                        Stack(children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 0.01825 * Get.height,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.0364 * Get.width,
                                    vertical: 0.0365 * Get.height),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 0.012 * Get.height,
                                    ),
                                    Text(
                                        'Enter the OTP sent to ${controller.authStateController.email}',
                                        textAlign: TextAlign.center),
                                    SizedBox(height: 0.0486 * Get.height),
                                    OtpTextField(
                                      numberOfFields: 6,
                                      focusedBorderColor: const Color.fromARGB(
                                          224, 68, 170, 50),
                                      borderWidth: 1.5,
                                      enabledBorderColor:
                                          Color.fromARGB(155, 255, 193, 7),
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
                                    SizedBox(height: 0.073 * Get.height),
                                    Obx(
                                      () => Container(
                                        width: 0.729 * Get.width,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    232, 235, 181, 19),
                                                width: 0.0072 * Get.width),
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
                                                            20 *
                                                                Get.pixelRatio),
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
                                                      SizedBox(
                                                        width: 0.27 * Get.width,
                                                      ),
                                                      CircularCountDownTimer(
                                                        textStyle: TextStyle(
                                                            fontSize: 3.42 *
                                                                Get.pixelRatio,
                                                            color: AppColor
                                                                .bgBlackColor),
                                                        isTimerTextShown: true,
                                                        isReverse: true,
                                                        onComplete: () => {
                                                          controller
                                                              .resendIsAllowed
                                                              .value = true
                                                        },
                                                        width: 0.085075 *
                                                            Get.width,
                                                        height:
                                                            0.0425 * Get.height,
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
                                    height: 0.042 * Get.height,
                                    width: controller.Pressed.value
                                        ? 0.437 * Get.width
                                        : 0.085 * Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.5714285714 * Get.pixelRatio),
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
