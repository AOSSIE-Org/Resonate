import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({Key? key}) : super(key: key);

  var passedOnArgs = Get.arguments;
  var email = Get.arguments[0];
  var password = Get.arguments[1];
  var confpassword = Get.arguments[1];
  var otpID = Get.arguments[3];

  var controller = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 30,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(161, 112, 106, 80),
                        Color.fromARGB(232, 60, 58, 52)
                      ])),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Current Email: ",
                          style: TextStyle(color: AppColor.yellowColor),
                        ),
                        Text(
                          email,
                          style: TextStyle(color: Colors.white),
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              Column(
                children: [
                  const Text(
                      "An OTP for Email Verification has been sent to your email. Please enter the OTP received",
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  OtpTextField(
                    numberOfFields: 6,
                    focusedBorderColor: AppColor.greenColor,
                    enabledBorderColor: AppColor.yellowColor,
                    showFieldAsBox: true,
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) async {
                      await controller.verifyOTP(
                          verificationCode, otpID, email);
                      String result =
                          await controller.checkVerificationStatus();
                      if (result == "true") {
                        Get.snackbar("Verification Complete",
                            "Congratulations you have verified your Email");
                        await controller.signup(email, password);
                      } else {
                        Get.snackbar("Verification Failed",
                            "OTP mismatch occured please try again");
                      }
                    },
                  ),
                  const SizedBox(height: 60),
                  Obx(
                    () => ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: controller.resendIsAllowed.value
                                ? MaterialStateProperty.all(
                                    AppColor.yellowColor)
                                : MaterialStateProperty.all(
                                    const Color.fromARGB(255, 74, 74, 74))),
                        onPressed: controller.resendIsAllowed.value
                            ? () {
                                controller.resendIsAllowed.value = false;
                                controller.sendOTP(
                                    email, password, confpassword);
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
                            : CircularCountDownTimer(
                                textStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                isTimerTextShown: true,
                                isReverse: true,
                                onComplete: () =>
                                    {controller.resendIsAllowed.value = true},
                                width: 35,
                                height: 35,
                                duration: 30,
                                backgroundColor: AppColor.yellowColor,
                                fillColor: AppColor.greenColor,
                                ringColor:
                                    const Color.fromARGB(255, 151, 149, 149),
                              )),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Incorrect Email?  "),
                      GestureDetector(
                        onTap: () {
                          controller.emailController.clear();
                          Get.toNamed(AppRoutes.signup,
                              arguments: passedOnArgs);
                        },
                        child: const Text(
                          "Update Email",
                          style: TextStyle(color: AppColor.yellowColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
