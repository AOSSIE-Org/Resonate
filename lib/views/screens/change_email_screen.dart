import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/change_email_controller.dart';

import '../../utils/ui_sizes.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({super.key});

  final controller = Get.put(ChangeEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Change Email'),
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
                      : "Enter Valid Email Address",
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.alternate_email_rounded,
                    ),
                    labelText: "New Email",
                  ),
                ),
                SizedBox(
                  height: UiSizes.height_20,
                ),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordFieldVisible.value,
                    validator: (value) =>
                        value! == "" ? "Password can't be empty" : null,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      // number of lines the error text would wrap
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                      ),
                      labelText: "Current Password",
                      suffixIcon: Semantics(
                        label: (controller.isPasswordFieldVisible.value) ? "Hide password" : "Show password",
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
                const Text(
                  'For added security, you must provide your account\'s current password when changing your email address. After changing your email, use the updated email for future logins.',
                ),
                SizedBox(
                  height: UiSizes.height_30,
                ),
                const MergeSemantics(
                  child: Column(
                    children: [
                      Text(
                        '(Only for users who logged in using Google or Github)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        'To change your email, please enter a new password in the "Current Password" field. Be sure to remember this password, as you\'ll need it for any future email changes. Moving forward, you can log in using Google/GitHub or your new email and password combination.',
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
                          await controller.changeEmail();
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
                          : const Text('Change Email'),
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
