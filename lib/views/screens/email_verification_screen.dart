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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: Image.asset("assets/images/aossie_logo.png"),
                        ),
                        const SizedBox(height: 15),
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
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            Text(
                                'Enter the OTP sent to ${controller.authStateController.email}',
                                textAlign: TextAlign.center),
                            const SizedBox(height: 40),
                            OtpTextField(
                              numberOfFields: 6,
                              focusedBorderColor:
                                  const Color.fromARGB(224, 68, 170, 50),
                              enabledBorderColor:
                                  const Color.fromARGB(190, 253, 212, 31),
                              showFieldAsBox: true,
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) async {
                                controller.isVerifying.value = true;
                                await controller.verifyOTP(verificationCode);
                                if (controller.res_verify.response ==
                                    '{"message":"null"}') {
                                  String result = await controller
                                      .checkVerificationStatus();
                                  if (result == "true") {
                                    Get.snackbar("Verification Complete",
                                        "Congratulations you have verified your Email");
                                    await controller.setVerified();
                                    if (controller.res_set_verified.response ==
                                        '{"message":"null"}') {
                                      controller.isVerifying.value = false;
                                      controller.authStateController
                                          .setUserProfileData();
                                      Get.toNamed(AppRoutes.tabview);
                                    } else {
                                      controller.isVerifying.value = false;
                                      Get.snackbar('Oops',
                                          controller.res_set_verified.response);
                                    }
                                  } else {
                                    controller.isVerifying.value = false;
                                    Get.snackbar("Verification Failed",
                                        "OTP mismatch occured please try again");
                                  }
                                } else {
                                  Get.snackbar(
                                      'Oops', controller.res_verify.response);
                                }
                              },
                            ),
                            const SizedBox(height: 60),
                            Obx(
                              () => ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          controller.resendIsAllowed.value
                                              ? MaterialStateProperty.all(
                                                  AppColor.yellowColor)
                                              : MaterialStateProperty.all(
                                                  const Color.fromARGB(
                                                      255, 74, 74, 74))),
                                  onPressed: controller.resendIsAllowed.value
                                      ? () {
                                          controller.resendIsAllowed.value =
                                              false;
                                          controller.sendOTP();
                                          Get.snackbar("OTP Resent",
                                              "Please do check your mail for a new OTP");
                                        }
                                      : () {
                                          Get.snackbar("Hold on",
                                              "Please wait till the timer completes");
                                        },
                                  child: controller.resendIsAllowed.value
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
                                              width: 65,
                                            ),
                                            CircularCountDownTimer(
                                              textStyle: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColor.bgBlackColor),
                                              isTimerTextShown: true,
                                              isReverse: true,
                                              onComplete: () => {
                                                controller.resendIsAllowed
                                                    .value = true
                                              },
                                              width: 35,
                                              height: 35,
                                              duration: 30,
                                              backgroundColor:
                                                  AppColor.yellowColor,
                                              fillColor: Color.fromARGB(
                                                  255, 74, 74, 74),
                                              ringColor: Color.fromARGB(
                                                  255, 130, 130, 130),
                                            ),
                                          ],
                                        )),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
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
