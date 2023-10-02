import 'dart:ui';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/email_verify_controller.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({Key? key}) : super(key: key);

  final controller = Get.find<AuthenticationController>();
  final emailVerifyController = Get.find<EmailVerifyController>();
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
                        horizontal: UiSizes.width_20,
                        vertical: UiSizes.height_10),
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
                                    fontSize: UiSizes.size_25),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Material(
                                  child: InkWell(
                                    onTap: () =>
                                        {Get.toNamed(AppRoutes.tabview)},
                                    child: Ink(
                                        height: UiSizes.height_30,
                                        width: UiSizes.width_100,
                                        decoration: BoxDecoration(
                                          gradient: AppColor.gradientBg,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Text("Back",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: UiSizes.size_14)),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: UiSizes.height_80),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: UiSizes.height_40,
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
                              style: TextStyle(fontSize: UiSizes.size_20),
                            )),
                          ),
                        ),
                        SizedBox(height: UiSizes.height_90),
                        Stack(children: [
                          Column(
                            children: [
                              SizedBox(
                                height: UiSizes.height_15,
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
                                    horizontal: UiSizes.width_16,
                                    vertical: UiSizes.height_30),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: UiSizes.height_10,
                                    ),
                                    Text(
                                      'Enter the OTP sent to ${controller.authStateController.email}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: UiSizes.size_14,
                                      ),
                                    ),
                                    SizedBox(height: UiSizes.height_40),
                                    OtpTextField(
                                      textStyle:
                                          TextStyle(fontSize: UiSizes.size_14),
                                      fieldWidth: UiSizes.width_40,
                                      numberOfFields: 6,
                                      focusedBorderColor: const Color.fromARGB(
                                          224, 68, 170, 50),
                                      borderWidth: UiSizes.width_1_5,
                                      enabledBorderColor:
                                          Color.fromARGB(155, 255, 193, 7),
                                      showFieldAsBox: true,
                                      //runs when every textfield is filled
                                      onSubmit:
                                          (String verificationCode) async {
                                        emailVerifyController
                                            .isVerifying.value = true;
                                        await emailVerifyController
                                            .verifyOTP(verificationCode);
                                        if (emailVerifyController
                                                .responseVerify.response ==
                                            '{"message":"null"}') {
                                          String result =
                                              await emailVerifyController
                                                  .checkVerificationStatus();
                                          if (result == "true") {
                                            Get.snackbar(
                                                "Verification Complete",
                                                "Congratulations you have verified your Email");
                                            await emailVerifyController
                                                .setVerified();
                                            if (emailVerifyController
                                                    .responseSetVerified
                                                    .response ==
                                                '{"message":"null"}') {
                                              emailVerifyController
                                                  .isVerifying.value = false;
                                              controller.authStateController
                                                  .setUserProfileData();
                                              Get.offAllNamed(AppRoutes.tabview);
                                            } else {
                                              emailVerifyController
                                                  .isVerifying.value = false;
                                              Get.snackbar(
                                                  'Oops',
                                                  emailVerifyController
                                                      .responseSetVerified
                                                      .response);
                                            }
                                          } else {
                                            emailVerifyController
                                                .isVerifying.value = false;
                                            Get.snackbar("Verification Failed",
                                                "OTP mismatch occured please try again");
                                          }
                                        } else {
                                          Get.snackbar(
                                              'Oops',
                                              emailVerifyController
                                                  .responseVerify.response);
                                        }
                                      },
                                    ),
                                    SizedBox(height: UiSizes.height_60),
                                    Obx(
                                      () => Container(
                                        width: UiSizes.width_300,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    232, 235, 181, 19),
                                                width: UiSizes.width_3),
                                            borderRadius:
                                                BorderRadius.circular(70),
                                            gradient: emailVerifyController
                                                    .resendIsAllowed.value
                                                ? AppColor.gradientBg
                                                : const LinearGradient(colors: [
                                                    Color.fromARGB(
                                                        255, 74, 74, 74),
                                                    Color.fromARGB(
                                                        255, 68, 63, 63)
                                                  ])),
                                        child: SizedBox(
                                          height: UiSizes.height_45,
                                          width: UiSizes.width_294,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              UiSizes.size_70),
                                                      side: const BorderSide(
                                                          width: 0,
                                                          color: Colors
                                                              .transparent)),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent),
                                              onPressed: emailVerifyController
                                                      .resendIsAllowed.value
                                                  ? () {
                                                      emailVerifyController
                                                          .resendIsAllowed
                                                          .value = false;
                                                      emailVerifyController.clearTextField.value=true;
                                                      emailVerifyController
                                                          .sendOTP();
                                                      Get.snackbar("OTP Resent",
                                                          "Please do check your mail for a new OTP");
                                                    }
                                                  : () {
                                                      Get.snackbar("Hold on",
                                                          "Please wait till the timer completes");
                                                    },
                                              child: emailVerifyController
                                                      .resendIsAllowed.value
                                                  ? Text(
                                                      "Resend OTP",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            UiSizes.size_14,
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Resend OTP?",
                                                          style: TextStyle(
                                                              fontSize: UiSizes
                                                                  .size_14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              UiSizes.width_111,
                                                        ),
                                                        CircularCountDownTimer(
                                                          textStyle: TextStyle(
                                                              fontSize: UiSizes
                                                                  .size_12,
                                                              color: AppColor
                                                                  .bgBlackColor),
                                                          isTimerTextShown:
                                                              true,
                                                          isReverse: true,
                                                          onComplete: () => {
                                                            emailVerifyController
                                                                .resendIsAllowed
                                                                .value = true
                                                          },
                                                          width:
                                                              UiSizes.width_33,
                                                          height:
                                                              UiSizes.heigth_33,
                                                          duration: 30,
                                                          backgroundColor:
                                                              Colors.amber,
                                                          fillColor: const Color
                                                              .fromARGB(
                                                              255, 74, 74, 74),
                                                          ringColor: const Color
                                                              .fromARGB(255,
                                                              130, 130, 130),
                                                        ),
                                                      ],
                                                    )),
                                        ),
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
                                  emailVerifyController.isExpanded.value =
                                      !emailVerifyController.isExpanded.value;
                                  if (emailVerifyController.isExpanded.value ==
                                      false) {
                                    emailVerifyController.shouldDisplay.value =
                                        false;
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
                                    height: UiSizes.heigth_35,
                                    width:
                                        emailVerifyController.isExpanded.value
                                            ? UiSizes.width_180
                                            : UiSizes.width_35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.5714285714 * Get.pixelRatio),
                                      color: Color.fromARGB(186, 255, 255, 255),
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                    child: emailVerifyController
                                            .shouldDisplay.value
                                        ? Center(
                                            child: Text(
                                              "Verify Your Email",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: UiSizes.size_14),
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
          emailVerifyController.isVerifying.value
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
