import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/authentication_controller.dart';
import '../../routes/app_routes.dart';
import '../../themes/theme_controller.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({super.key});

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  var controller = Get.find<AuthenticationController>();
  var themeController = Get.find<ThemeController>();

  @override
  void initState() {
    controller.loginFormKey = GlobalKey<FormState>();
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
            key: controller.loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: UiSizes.height_60,
                    ),
                    Text(
                      "Login",
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
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordFieldVisible.value,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_30,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: () async {
                            if (!controller.isLoading.value) {
                              if (controller.loginFormKey.currentState!
                                  .validate()) {
                                await controller.login();
                              }
                            }
                          },
                          child: controller.isLoading.value
                              ? Center(
                                  child: LoadingAnimationWidget
                                      .horizontalRotatingDots(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: UiSizes.size_40,
                                  ),
                                )
                              : const Text(
                                  "Login",
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(AppRoutes.forgotPassword);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New to Resonate? "),
                    GestureDetector(
                      onTap: () {
                        controller.emailController.clear();
                        controller.passwordController.clear();
                        controller.confirmPasswordController.clear();
                        controller.isPasswordFieldVisible.value = false;
                        controller.isConfirmPasswordFieldVisible.value = false;
                        Get.offNamed(AppRoutes.signup);
                      },
                      child: Text(
                        "Register",
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
