import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var passedOnArgs = Get.arguments;
  var controller = Get.find<AuthenticationController>();
  var email;

  void setTimmer() async {
    controller.signup_isallowed.value = false;
    var duration = const Duration(minutes: 1);
    Timer(duration, () {
      controller.signup_isallowed.value = true;
    });
  }

  @override
  void initState() {
    controller.emailController.text =
        !(passedOnArgs == null) ? "< please enter updated email >" : "";
    if (!(passedOnArgs == null)) {
      email = passedOnArgs[0];
    }
    controller.passwordController.text =
        !(passedOnArgs == null) ? passedOnArgs[1] : "";
    controller.confirmPasswordController.text =
        !(passedOnArgs == null) ? passedOnArgs[2] : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: Get.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: controller.registrationFormKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.asset("assets/images/aossie_logo.png"),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Welcome to Resonate",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    style: TextStyle(
                        color: !(passedOnArgs == null)
                            ? AppColor.greenColor
                            : Colors.white),
                    validator: (value) => value!.isValidEmail()
                        ? null
                        : "Enter Valid Email Address",
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email),
                      labelText: "Email ID",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    validator: (value) => value!.isValidPassword()
                        ? null
                        : "Password must be atleast 6 digit, with one lowercase,\none uppercase and one numeric value.",
                    controller: controller.passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.lock_outline_rounded,
                      ),
                      labelText: "Password",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => TextFormField(
                      validator: (value) => value!.isSamePassword(
                              controller.passwordController.text)
                          ? null
                          : "Password do not match",
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isPasswordFieldVisible.value,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.lock_outline_rounded,
                        ),
                        labelText: "Confirm Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.isPasswordFieldVisible.value =
                                !controller.isPasswordFieldVisible.value;
                          },
                          splashRadius: 20,
                          icon: Icon(
                            controller.isPasswordFieldVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.signup_isallowed.value
                          ? () async {
                              setTimmer();
                              var result = await controller.sendOTP(
                                  !(email == null)
                                      ? email
                                      : controller.emailController.text,
                                  controller.passwordController.text,
                                  controller.confirmPasswordController.text);
                              if (passedOnArgs != null && result) {
                                Get.snackbar("Email Updated",
                                    "OTP sent to the updates email");
                              }
                            }
                          : null,
                      child: controller.isLoading.value
                          ? Center(
                              child:
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                color: Colors.black,
                                size: 40,
                              ),
                            )
                          : const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          indent: 20.0,
                          endIndent: 10.0,
                          thickness: 1,
                        ),
                      ),
                      Text("OR"),
                      Expanded(
                        child: Divider(
                          indent: 10.0,
                          endIndent: 20.0,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFFFE0),
                    ),
                    onPressed: () async {
                      if (!controller.isLoading.value) {
                        await controller.loginWithGoogle();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/images/google_icon.png"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Sign up with Google',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already on Resonate?  "),
                      GestureDetector(
                        onTap: () => Get.offNamed(AppRoutes.login),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: AppColor.yellowColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
