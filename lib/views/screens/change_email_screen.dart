import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/change_email_controller.dart';

import '../../themes/theme_controller.dart';

import '../../utils/ui_sizes.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({super.key});

  final InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Get.find<ThemeController>().primaryColor.value,
        width: UiSizes.width_2,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeEmailController());
    // final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: controller.changeEmailFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.emailController,
                validator: (value) =>
                    value!.isValidEmail() ? null : "Enter Valid Email Address",
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                cursorRadius: const Radius.circular(10),
                decoration: inputDecoration.copyWith(
                  prefixIcon: const Icon(
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
                  style: TextStyle(fontSize: UiSizes.size_14),
                  controller: controller.passwordController,
                  validator: (value) =>
                      value! == "" ? "Password can't be empty" : null,
                  obscureText: !controller.isPasswordFieldVisible.value,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: inputDecoration.copyWith(
                    // number of lines the error text would wrap
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                    ),
                    labelText: "Current Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.isPasswordFieldVisible.value =
                            !controller.isPasswordFieldVisible.value;
                      },
                      splashRadius: UiSizes.height_20,
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
              SizedBox(
                height: UiSizes.height_30,
              ),
              const Text(
                  'For added security, you must provide your account\'s current password when changing your email address. After changing your email, use the updated email for future logins.'),
              SizedBox(
                height: UiSizes.height_30,
              ),
              Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    if (!controller.isLoading.value) {
                      await controller.changeEmail();
                    }
                  },
                  child: controller.isLoading.value
                      ? Center(
                          child: LoadingAnimationWidget.horizontalRotatingDots(
                            color: Colors.black,
                            size: UiSizes.size_40,
                          ),
                        )
                      : const Text(
                          'Change Email',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
