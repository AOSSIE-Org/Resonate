import 'package:flutter/material.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final authController = Get.find<AuthenticationController>();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Enter your new password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    size: 23,
                  ),
                  labelText: "New Password",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                authController.resetPassword(passwordController.text);
              },
              color: Colors.amber,
              child: const Text(
                'Set New Password',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
