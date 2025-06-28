import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/change_email_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';

import '../../utils/ui_sizes.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({super.key});

  final controller = Get.put(ChangeEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changeEmail),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: UiSizes.height_20,
            horizontal: UiSizes.width_20,
          ),
          child: Form(
            key: controller.changeEmailFormKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) => value!.isValidEmail()
                      ? null
                      : AppLocalizations.of(context)!.enterValidEmail,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.alternate_email_rounded,
                    ),
                    labelText: AppLocalizations.of(context)!.newEmail,
                  ),
                ),
                SizedBox(
                  height: UiSizes.height_20,
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
                      // number of lines the error text would wrap
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                      ),
                      labelText: AppLocalizations.of(context)!.currentPassword,
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
                              color: Theme.of(context).colorScheme.onSecondary,
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
                Text(
                  AppLocalizations.of(context)!.emailChangeInfo,
                ),
                SizedBox(
                  height: UiSizes.height_30,
                ),
                MergeSemantics(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.oauthUsersMessage,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.oauthUsersEmailChangeInfo,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: UiSizes.height_30,
                ),
                Obx(
                  () => SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!controller.isLoading.value) {
                          await controller.changeEmail(context);
                        }
                      },
                      child: controller.isLoading.value
                          ? Center(
                              child:
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: UiSizes.size_40,
                              ),
                            )
                          : Text(AppLocalizations.of(context)!.changeEmail),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
