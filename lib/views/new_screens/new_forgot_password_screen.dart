import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/authentication_controller.dart';

import '../../utils/ui_sizes.dart';

class NewForgotPasswordScreen extends StatefulWidget {
  const NewForgotPasswordScreen({super.key});

  @override
  State<NewForgotPasswordScreen> createState() => _NewForgotPasswordScreenState();
}

class _NewForgotPasswordScreenState extends State<NewForgotPasswordScreen> {


  final authController = Get.find<AuthenticationController>();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
                controller: emailController,
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
                  onPressed: () {},
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
