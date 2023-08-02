import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';

class SignupScreen extends StatelessWidget {
  final controller = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: Get.height * 0.92,
            padding: EdgeInsets.symmetric(
                horizontal: 0.048 * Get.width, vertical: 0.0121 * Get.height),
            child: Form(
              key: controller.registrationFormKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 0.4375 * Get.width,
                    height: 0.219 * Get.height,
                    child: Image.asset("assets/images/aossie_logo.png"),
                  ),
                  SizedBox(height: 0.01825 * Get.height),
                  Text(
                    "Welcome to Resonate",
                    style: TextStyle(
                        fontSize: 0.015 * Get.height + 0.03 * Get.width),
                  ),
                  SizedBox(height: 0.01825 * Get.height),
                  SizedBox(
                    height: 0.07995 * Get.height,
                    child: TextFormField(
                      validator: (value) => value!.isValidEmail()
                          ? null
                          : "Enter Valid Email Address",
                      style: TextStyle(
                          fontSize: 0.0085 * Get.height + 0.017 * Get.width),
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        icon: Icon(
                          size: 0.014 * Get.height + 0.029 * Get.width,
                          Icons.alternate_email,
                        ),
                        labelText: "Email ID",
                      ),
                    ),
                  ),
                  SizedBox(height: 0.012 * Get.height),
                  SizedBox(
                    height: 0.07995 * Get.height,
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 0.0085 * Get.height + 0.017 * Get.width),
                      validator: (value) => value!.isValidPassword()
                          ? null
                          : "Password must be atleast 6 digit, with one lowercase,\none uppercase and one numeric value.",
                      controller: controller.passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        icon: Icon(
                          size: 0.014 * Get.height + 0.029 * Get.width,
                          Icons.lock_outline_rounded,
                        ),
                        labelText: "Password",
                      ),
                    ),
                  ),
                  SizedBox(height: 0.012 * Get.height),
                  SizedBox(
                    height: 0.07995 * Get.height,
                    child: Obx(
                      () => TextFormField(
                        style: TextStyle(
                            fontSize: 0.0085 * Get.height + 0.017 * Get.width),
                        validator: (value) => value!.isSamePassword(
                                controller.passwordController.text)
                            ? null
                            : "Password do not match",
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isPasswordFieldVisible.value,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          icon: Icon(
                            size: 0.014 * Get.height + 0.029 * Get.width,
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
                              size: 0.014 * Get.height + 0.029 * Get.width,
                              controller.isPasswordFieldVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.03 * Get.height),
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.signupisallowed.value
                          ? () async {
                              if (controller.registrationFormKey.currentState!
                                  .validate()) {
                                controller.signupisallowed.value = false;
                                var isSignedin = await controller.signup();
                                if (isSignedin) {
                                  Get.toNamed(AppRoutes.onBoarding);
                                  Get.snackbar("Signed Up Successfully",
                                      "You have successfully created a new account");
                                } else {
                                  controller.signupisallowed.value = true;
                                }
                              }
                            }
                          : null,
                      child: controller.isLoading.value
                          ? Center(
                              child:
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                color: Colors.black,
                                size: 0.024 * Get.height + 0.048 * Get.width,
                              ),
                            )
                          : Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    0.024 * Get.width + 0.012 * Get.height,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 0.0206888 * Get.height),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          indent: 0.048 * Get.width,
                          endIndent: 0.024 * Get.width,
                          thickness: 0.0012 * Get.height,
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                            fontSize: 0.0085 * Get.height + 0.017 * Get.width),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 0.048 * Get.width,
                          endIndent: 0.024 * Get.width,
                          thickness: 0.0012 * Get.height,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.0206888 * Get.height),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFFFFE0),
                    ),
                    onPressed: () async {
                      await controller.loginWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 0.0365 * Get.height,
                          width: 0.0729 * Get.width,
                          child: Image.asset("assets/images/google_icon.png"),
                        ),
                        SizedBox(
                          width: 0.024 * Get.width,
                        ),
                        Text(
                          'Sign up with Google',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 0.0109 * Get.height + 0.02187 * Get.width,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already on Resonate?  ",
                        style: TextStyle(
                            fontSize: 0.017 * Get.width + 0.0085 * Get.height),
                      ),
                      GestureDetector(
                        onTap: () => Get.offNamed(AppRoutes.login),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: AppColor.yellowColor,
                              fontSize:
                                  0.017 * Get.width + 0.0085 * Get.height),
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
