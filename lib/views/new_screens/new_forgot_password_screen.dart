import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/controllers/forgot_password_controller.dart';

import '../../utils/ui_sizes.dart';

class NewForgotPasswordScreen extends StatefulWidget {
  const NewForgotPasswordScreen({super.key});

  @override
  State<NewForgotPasswordScreen> createState() => _NewForgotPasswordScreenState();
}

class _NewForgotPasswordScreenState extends State<NewForgotPasswordScreen> {

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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Forgot Password",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: UiSizes.height_40,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your registered email address to reset your password.",
                ),
              ),
              SizedBox(
                height: UiSizes.height_20,
              ),
              TextFormField(
                controller: forgotPasswordController.emailController,
                validator: (value) => value!.isValidEmail()
                    ? null
                    : "Enter Valid Email Address",
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
              SizedBox(
                height: UiSizes.height_30,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {

                    if(forgotPasswordController.forgotPasswordFormKey.currentState!.validate()){
                      forgotPasswordController.sendRecoveryEmail();
                    }



                  },
                  child: const Text(
                    "Next",
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
