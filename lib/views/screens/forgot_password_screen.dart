import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import '../../themes/theme_controller.dart';
import 'reset_password_screen.dart';
import '../../utils/ui_sizes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final authController = Get.find<AuthenticationController>();
  TextEditingController emailController = TextEditingController();
  var themeController = Get.find<ThemeController>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
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
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Enter your email and we will send you a reset link',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 300, // Adjust the width as needed
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_4),
              child: TextFormField(
                validator: (value) {
                  return null;
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: UiSizes.size_14,
                  color: themeController.loadTheme() == 'dark'
                      ? Colors.white
                      : Colors.black,
                ),
                autocorrect: false,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.alternate_email,
                    size: UiSizes.size_23,
                  ),
                  errorStyle: TextStyle(fontSize: UiSizes.size_14),
                  labelText: "Email ID",
                  labelStyle: TextStyle(
                    color: themeController.loadTheme() == 'dark'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            MaterialButton(
              onPressed: () {
                authController.resetPassword(emailController.text);
              },
              child: Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
