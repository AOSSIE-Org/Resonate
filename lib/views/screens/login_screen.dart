import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/l10n/app_localizations.dart';
import '../../controllers/authentication_controller.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.find<AuthenticationController>();

  @override
  void initState() {
    controller.loginFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
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
                      AppLocalizations.of(context)!.login,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: UiSizes.height_40,
                    ),
                    TextFormField(
                      validator: (value) => value!.isValidEmail()
                          ? null
                          : AppLocalizations.of(context)!
                              .enterValidEmailAddress,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.email,
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_10,
                    ),
                    Obx(
                      () => TextFormField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordFieldVisible.value,
                        validator: (value) => value! == ""
                            ? AppLocalizations.of(context)!.passwordEmpty
                            : null,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.password,
                          suffixIcon: Semantics(
                            label: (controller.isPasswordFieldVisible.value)
                                ? AppLocalizations.of(context)!.hidePassword
                                : AppLocalizations.of(context)!.showPassword,
                            child: GestureDetector(
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
                                await controller.login(context);
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
                              : Text(
                                  AppLocalizations.of(context)!.login,
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
                        AppLocalizations.of(context)!.forgotPassword,
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
                    Text(AppLocalizations.of(context)!.newToResonate),
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
                        AppLocalizations.of(context)!.register,
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
