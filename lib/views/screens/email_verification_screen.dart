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
    final  emailVerifyController= Get.find<EmailVerifyController>();
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
                                    fontSize:
                                       UiSizes.size_24_6),
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
                                        child: Center(
                                          child: Text("Back",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      0.0085 * Get.height +
                                                          0.017 * Get.width)),
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
                              style: TextStyle(
                                  fontSize:
                                      0.012 * Get.height + 0.024 * Get.width),
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
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 0.0085 * Get.height +
                                            0.017 * Get.width,
                                      ),
                                    ),
                                    SizedBox(height: 0.0486 * Get.height),
                                    OtpTextField(
                                      fieldWidth: 0.09722 * Get.width,
                                      numberOfFields: 6,
                                      focusedBorderColor: const Color.fromARGB(
                                          224, 68, 170, 50),
                                      borderWidth: 0.00364 * Get.width,
                                      enabledBorderColor:
                                          Color.fromARGB(155, 255, 193, 7),
                                      showFieldAsBox: true,
                                      //runs when every textfield is filled
                                      onSubmit:
                                          (String verificationCode) async {
                                        emailVerifyController.isVerifying.value = true;
                                        await emailVerifyController
                                            .verifyOTP(verificationCode);
                                        if (emailVerifyController.responseVerify.response ==
                                            '{"message":"null"}') {
                                          String result = await emailVerifyController
                                              .checkVerificationStatus();
                                          if (result == "true") {
                                            Get.snackbar(
                                                "Verification Complete",
                                                "Congratulations you have verified your Email");
                                            await emailVerifyController.setVerified();
                                            if (emailVerifyController.responseSetVerified
                                                    .response ==
                                                '{"message":"null"}') {
                                              emailVerifyController.isVerifying.value =
                                                  false;
                                              controller.authStateController
                                                  .setUserProfileData();
                                              Get.toNamed(AppRoutes.tabview);
                                            } else {
                                              emailVerifyController.isVerifying.value =
                                                  false;
                                              Get.snackbar(
                                                  'Oops',
                                                  emailVerifyController.responseSetVerified
                                                      .response);
                                            }
                                          } else {
                                            emailVerifyController.isVerifying.value =
                                                false;
                                            Get.snackbar("Verification Failed",
                                                "OTP mismatch occured please try again");
                                          }
                                        } else {
                                          Get.snackbar('Oops',
                                              emailVerifyController.responseVerify.response);
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
                                          height: 0.05476 * Get.height,
                                          width: 0.7146 * Get.width,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(0.0425 *
                                                                  Get.height +
                                                              0.085 *
                                                                  Get.width),
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
                                                      emailVerifyController.resendIsAllowed
                                                          .value = false;
                                                      emailVerifyController.sendOTP();
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
                                                        fontSize: 0.0085 *
                                                                Get.height +
                                                            0.017 * Get.width,
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
                                                              fontSize: 0.0085 *
                                                                      Get
                                                                          .height +
                                                                  0.017 *
                                                                      Get.width),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              0.27 * Get.width,
                                                        ),
                                                        CircularCountDownTimer(
                                                          textStyle: TextStyle(
                                                              fontSize: 0.0073 *
                                                                      Get
                                                                          .height +
                                                                  0.01458 *
                                                                      Get.width,
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
                                                          width: 0.085075 *
                                                              Get.width,
                                                          height: 0.0425 *
                                                              Get.height,
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
                                  emailVerifyController.pressed.value =
                                      !emailVerifyController.pressed.value;
                                  if (emailVerifyController.pressed.value == false) {
                                    emailVerifyController.shouldDisplay.value = false;
                                  }
                                },
                                child: AnimatedContainer(
                                    onEnd: () {
                                      if (emailVerifyController.pressed.value == true) {
                                        emailVerifyController.shouldDisplay.value = true;
                                      }
                                    },
                                    height: 0.042594 * Get.height,
                                    width: emailVerifyController.pressed.value
                                        ? 0.437 * Get.width
                                        : 0.085 * Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          8.5714285714 * Get.pixelRatio),
                                      color: Color.fromARGB(186, 255, 255, 255),
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                    child: emailVerifyController.shouldDisplay.value
                                        ? Center(
                                            child: Text(
                                              "Verify Your Email",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      0.0085 * Get.height +
                                                          0.017 * Get.width),
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
