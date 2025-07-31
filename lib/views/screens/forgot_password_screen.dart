import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/forgot_password_controller.dart';

import '../../utils/ui_sizes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordController = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
        width: double.maxFinite,
        child: Form(
          key: forgotPasswordController.forgotPasswordFormKey,
          child: Column(
            children: [
              SizedBox(
                height: UiSizes.height_60,
              ),
              MergeSemantics(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.forgotPasswordMessage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: UiSizes.height_20,
              ),
              TextFormField(
                controller: forgotPasswordController.emailController,
                validator: (value) => value!.isValidEmail()
                    ? null
                    : AppLocalizations.of(context)!.enterValidEmailAddress,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.email,
                ),
              ),
              SizedBox(
                height: UiSizes.height_30,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    if (forgotPasswordController
                        .forgotPasswordFormKey.currentState!
                        .validate()) {
                      forgotPasswordController.sendRecoveryEmail();
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.next,
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
