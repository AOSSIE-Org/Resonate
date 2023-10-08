import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/password_strength_checker_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/auth_button.dart';
import 'package:resonate/views/widgets/password_strength_indicator.dart';

import '../../controllers/email_verify_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var controller = Get.find<AuthenticationController>();
  var emailVerifyController = Get.find<EmailVerifyController>();
  var passwordStrengthCheckerController =
      Get.find<PasswordStrengthCheckerController>();

  @override
  void initState() {
    controller.registrationFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: UiSizes.height_765,
          padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_20, vertical: UiSizes.height_10),
          child: Form(
            key: controller.registrationFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: UiSizes.height_40),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "Welcome to",
                          style: TextStyle(fontSize: UiSizes.size_25),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Resonate",
                            style: TextStyle(
                                fontSize: UiSizes.size_56,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UiSizes.height_20),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: UiSizes.height_2),
                    child: TextFormField(
                      validator: (value) => value!.isValidEmail()
                          ? null
                          : "Enter Valid Email Address",
                      style: TextStyle(fontSize: UiSizes.size_14),
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        icon: Icon(
                          size: UiSizes.size_23,
                          Icons.alternate_email,
                        ),
                        errorStyle: TextStyle(fontSize: UiSizes.size_14),
                        labelText: "Email ID",
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_10),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: UiSizes.height_2),
                    child: TextFormField(
                      style: TextStyle(fontSize: UiSizes.size_14),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: controller.passwordController,
                      validator: (value) =>
                          value! == "" ? "Password can't be empty" : null,
                      obscureText: true,
                      onChanged: (value) => passwordStrengthCheckerController
                          .passwordValidator(value),
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        errorMaxLines:
                            2, // number of lines the error text would wrap
                        icon: Icon(
                          size: UiSizes.size_23,
                          Icons.lock_outline_rounded,
                        ),
                        errorStyle: TextStyle(fontSize: UiSizes.size_14),
                        labelText: "Password",
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_10),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: UiSizes.height_2),
                    child: Obx(
                      () => TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: UiSizes.size_14),
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
                            size: UiSizes.size_23,
                            Icons.lock_outline_rounded,
                          ),
                          labelText: "Confirm Password",
                          errorStyle: TextStyle(fontSize: UiSizes.size_14),
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isPasswordFieldVisible.value =
                                  !controller.isPasswordFieldVisible.value;
                            },
                            splashRadius: 20,
                            icon: Icon(
                              size: UiSizes.size_23,
                              controller.isPasswordFieldVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_24_6),
                  Obx(
                    () => Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      visible:
                          passwordStrengthCheckerController.isVisible.value,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        opacity:
                            passwordStrengthCheckerController.isVisible.value
                                ? 1
                                : 0,
                        child: SizedBox(
                            height: UiSizes.height_40,
                            child: PasswordStrengthIndicator(
                              isPasswordSixCharacters:
                                  passwordStrengthCheckerController
                                      .isPasswordSixCharacters.value,
                              hasOneDigit: passwordStrengthCheckerController
                                  .hasOneDigit.value,
                              hasUpperCase: passwordStrengthCheckerController
                                  .hasUpperCase.value,
                              hasLowerCase: passwordStrengthCheckerController
                                  .hasLowerCase.value,
                              passwordSixCharactersTitle:
                                  "Password should be at least 6 characters long",
                              hasOneDigitTitle:
                                  "Include at least 1 numeric digit",
                              hasUpperCaseTitle:
                                  "Include at least 1 uppercase letter",
                              hasLowerCaseTitle:
                                  "Include at least 1 lowercase letter",
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_20),
                  Obx(
                    () => ElevatedButton(
                      onPressed: emailVerifyController.signupisallowed.value
                          ? () async {
                              if (controller.registrationFormKey.currentState!
                                  .validate()) {
                                emailVerifyController.signupisallowed.value =
                                    false;
                                var isSignedin = await controller.signup();
                                if (isSignedin) {
                                  Get.toNamed(AppRoutes.onBoarding);
                                  Get.snackbar("Signed Up Successfully",
                                      "You have successfully created a new account");
                                  emailVerifyController.signupisallowed.value =
                                      true;
                                } else {
                                  emailVerifyController.signupisallowed.value =
                                      true;
                                }
                              }
                            }
                          : null,
                      child: controller.isLoading.value
                          ? Center(
                              child:
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                color: Colors.black,
                                size: UiSizes.size_20,
                              ),
                            )
                          : Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: UiSizes.size_19,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          indent: UiSizes.width_20,
                          endIndent: UiSizes.width_10,
                          thickness: UiSizes.height_1,
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(fontSize: UiSizes.size_14),
                      ),
                      Expanded(
                        child: Divider(
                          indent: UiSizes.width_10,
                          endIndent: UiSizes.width_20,
                          thickness: UiSizes.height_1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UiSizes.height_24_6),
                  AuthButtonWidget(
                    onPressed: () async {
                      await controller.loginWithGoogle();
                    },
                    logoPath: "assets/images/google_icon.png",
                    authText: "Signup with Google",
                  ),
                  SizedBox(height: UiSizes.height_14),
                  AuthButtonWidget(
                    onPressed: () async {
                      await controller.loginWithGithub();
                    },
                    logoPath: AppImages.githubIconImage,
                    authText: "Signup with Github",
                  ),
                  SizedBox(height: UiSizes.height_20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already on Resonate?  ",
                        style: TextStyle(fontSize: UiSizes.size_14),
                      ),
                      GestureDetector(
                        onTap: () => Get.offNamed(AppRoutes.login),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: AppColor.yellowColor,
                              fontSize: UiSizes.size_14),
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
