import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/modules/authentication/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      builder: (controller) => Scaffold(
          appBar: AppBar(title: const Text("Verify Email")),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Email Verification has been sent your email. Please verify and login.", textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  controller.passwordController.clear();
                  Get.offNamed(AppRoutes.login);
                },
                child: const Text("Login"),
              )
            ],
          )
      ),
    );
  }
}
