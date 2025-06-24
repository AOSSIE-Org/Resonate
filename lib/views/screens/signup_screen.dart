import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/authentication_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../controllers/password_strength_checker_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/enums/log_type.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/snackbar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            key: controller.registrationFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: UiSizes.height_20,
                    ),                    Text(
                      AppLocalizations.of(context)!.createAccount,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: UiSizes.height_40,
                    ),
                    TextFormField(                      validator: (value) => value!.isValidEmail()
                          ? null
                          : AppLocalizations.of(context)!.enterValidEmailAddress,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.passwordController,
                        validator: (value) => value! == ""
                            ? AppLocalizations.of(context)!.passwordEmpty
                            : null,
                        obscureText: !controller.isPasswordFieldVisible.value,
                        onChanged: (value) => passwordStrengthCheckerController
                            .passwordValidator(value),
                        enableSuggestions: false,
                        autocorrect: false,                        decoration: InputDecoration(
                          errorMaxLines: 2,
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
                      height: UiSizes.height_10,
                    ),
                    Obx(
                      () => TextFormField(
                        validator: (value) => value!.isSamePassword(
                                controller.passwordController.text)
                            ? null
                            : AppLocalizations.of(context)!.passwordsNotMatch,
                        controller: controller.confirmPasswordController,
                        obscureText:
                            !controller.isConfirmPasswordFieldVisible.value,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.confirmPassword,
                          suffixIcon: Semantics(
                            label: (controller
                                    .isConfirmPasswordFieldVisible.value)
                                ? AppLocalizations.of(context)!.hidePassword
                                : AppLocalizations.of(context)!.showPassword,
                            child: GestureDetector(
                              onTap: () {
                                controller.isConfirmPasswordFieldVisible.value =
                                    !controller
                                        .isConfirmPasswordFieldVisible.value;
                              },
                              child: Container(
                                width: 56,
                                color: Colors.transparent,
                                child: Icon(
                                  controller.isConfirmPasswordFieldVisible.value
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
                              width: Get.width,                              child: PasswordStrengthIndicator(
                                isPasswordEightCharacters:
                                    passwordStrengthCheckerController
                                        .isPasswordEightCharacters.value,
                                hasOneDigit: passwordStrengthCheckerController
                                    .hasOneDigit.value,
                                hasUpperCase: passwordStrengthCheckerController
                                    .hasUpperCase.value,
                                hasLowerCase: passwordStrengthCheckerController
                                    .hasLowerCase.value,
                                hasOneSymbol: passwordStrengthCheckerController
                                    .hasOneSymbol.value,
                                passwordSixCharactersTitle:
                                    AppLocalizations.of(context)!.passwordRequirements,
                                hasOneDigitTitle:
                                    AppLocalizations.of(context)!.includeNumericDigit,
                                hasUpperCaseTitle:
                                    AppLocalizations.of(context)!.includeUppercase,
                                hasLowerCaseTitle:
                                    AppLocalizations.of(context)!.includeLowercase,
                                hasOneSymbolTitle: AppLocalizations.of(context)!.includeSymbol,
                                passStrengthVerifiedText: AppLocalizations.of(context)!.passwordIsStrong,
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
                                  var isSignedIn = await controller.signup(context);
                                  if (isSignedIn) {
                                    Get.toNamed(AppRoutes.onBoarding);                                    customSnackbar(
                                      AppLocalizations.of(context)!.signedUpSuccessfully,
                                      AppLocalizations.of(context)!.newAccountCreated,
                                      LogType.success,
                                    );

                                    SemanticsService.announce(
                                      AppLocalizations.of(context)!.newAccountCreated,
                                      TextDirection.ltr,
                                    );
                                    emailVerifyController
                                        .signUpIsAllowed.value = true;
                                  } else {
                                    emailVerifyController
                                        .signUpIsAllowed.value = true;
                                  }
                                }
                              }
                            : null,
                        child: controller.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: UiSizes.size_40,
                                ),
                              )                            : Text(
                                AppLocalizations.of(context)!.signUp,
                              ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,                  children: [
                    Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                    GestureDetector(
                      onTap: () {
                        controller.emailController.clear();
                        controller.passwordController.clear();
                        controller.confirmPasswordController.clear();
                        controller.isPasswordFieldVisible.value = false;
                        controller.isConfirmPasswordFieldVisible.value = false;
                        Get.offNamed(AppRoutes.loginScreen);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.login,
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
