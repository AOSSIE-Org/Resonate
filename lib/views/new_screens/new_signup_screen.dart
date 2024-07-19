import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/authentication_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../controllers/password_strength_checker_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/enums/message_type_enum.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/snackbar.dart';

class NewSignupScreen extends StatefulWidget {
  const NewSignupScreen({super.key});

  @override
  State<NewSignupScreen> createState() => _NewSignupScreenState();
}

class _NewSignupScreenState extends State<NewSignupScreen> {
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
    return PopScope(
      onPopInvoked: (didPop) {
        controller.emailController.clear();
        controller.passwordController.clear();
        controller.confirmPasswordController.clear();
        controller.isPasswordFieldVisible.value = false;
        controller.isConfirmPasswordFieldVisible.value = false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_20,
            vertical: UiSizes.height_20,
          ),
          width: double.maxFinite,
          child: Form(
            key: controller.registrationFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: UiSizes.height_20,
                    ),
                    Text(
                      "Create Account",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: UiSizes.height_40,
                    ),
                    TextFormField(
                      validator: (value) => value!.isValidEmail()
                          ? null
                          : "Enter Valid Email Address",
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_10,
                    ),
                    Obx(
                      () => TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.passwordController,
                        validator: (value) =>
                            value! == "" ? "Password can't be empty" : null,
                        obscureText: !controller.isPasswordFieldVisible.value,
                        onChanged: (value) => passwordStrengthCheckerController
                            .passwordValidator(value),
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          hintText: "Password",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.isPasswordFieldVisible.value =
                                  !controller.isPasswordFieldVisible.value;
                            },
                            child: Container(
                              width: 56,
                              color: Colors.transparent,
                              child: Icon(
                                controller.isPasswordFieldVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_10,
                    ),
                    Obx(
                      () => TextFormField(
                        validator: (value) => value!.isSamePassword(
                                controller.passwordController.text)
                            ? null
                            : "Password do not match",
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isConfirmPasswordFieldVisible.value,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.isConfirmPasswordFieldVisible.value =
                                  !controller.isConfirmPasswordFieldVisible.value;
                            },
                            child: Container(
                              width: 56,
                              color: Colors.transparent,
                              child: Icon(
                                controller.isConfirmPasswordFieldVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_20,
                    ),
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
                              height: UiSizes.height_45,
                              width: Get.width,
                              child: PasswordStrengthIndicator(
                                isPasswordEightCharacters:
                                    passwordStrengthCheckerController
                                        .isPasswordEightCharacters.value,
                                hasOneDigit: passwordStrengthCheckerController
                                    .hasOneDigit.value,
                                hasUpperCase: passwordStrengthCheckerController
                                    .hasUpperCase.value,
                                hasLowerCase: passwordStrengthCheckerController
                                    .hasLowerCase.value,
                                hasOneSymbol: passwordStrengthCheckerController.hasOneSymbol.value,
                                passwordSixCharactersTitle:
                                    "Password must be at least 8 characters long",
                                hasOneDigitTitle:
                                    "Include at least 1 numeric digit",
                                hasUpperCaseTitle:
                                    "Include at least 1 uppercase letter",
                                hasLowerCaseTitle:
                                    "Include at least 1 lowercase letter",
                                hasOneSymbolTitle: "Include at least 1 symbol",
                                validatedChecks:
                                    passwordStrengthCheckerController
                                        .validatedChecks.value,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_10,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: emailVerifyController.signUpIsAllowed.value
                            ? () async {
                          if (controller.registrationFormKey.currentState!
                              .validate()) {
                            emailVerifyController.signUpIsAllowed.value =
                            false;
                            var isSignedIn = await controller.signup();
                            if (isSignedIn) {
                              Get.toNamed(AppRoutes.onBoarding);
                              customSnackbar(
                                  "Signed Up Successfully",
                                  "You have successfully created a new account",
                                  MessageType.success);
                              emailVerifyController.signUpIsAllowed.value =
                              true;
                            } else {
                              emailVerifyController.signUpIsAllowed.value =
                              true;
                            }
                          }
                        }
                            : null,
                        child: controller.isLoading.value
                            ? Center(
                                child:
                                    LoadingAnimationWidget.horizontalRotatingDots(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: UiSizes.size_40,
                                ),
                              )
                            : const Text(
                                "Sign up",
                              ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        controller.emailController.clear();
                        controller.passwordController.clear();
                        controller.confirmPasswordController.clear();
                        controller.isPasswordFieldVisible.value = false;
                        controller.isConfirmPasswordFieldVisible.value = false;
                        Get.offNamed(AppRoutes.login);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
