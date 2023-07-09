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
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
        builder: (controller) => Scaffold(
                body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
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
                          ElevatedButton(
                            onPressed: () {
                              controller.sendOTP(email, password, confpassword);
                              Get.snackbar("OTP Resent",
                                  "Please do check your mail for a new OTP");
                            },
                            child: const Text(
                              "Resend OTP",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
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
            )));
  }
}
