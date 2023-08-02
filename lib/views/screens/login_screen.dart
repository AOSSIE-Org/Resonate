import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: Get.height * 0.95,
              padding: EdgeInsets.symmetric(
                  horizontal: 0.0486 * Get.width, vertical: 0.012 * Get.height),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 0.437 * Get.width,
                      height: 0.219 * Get.height,
                      child: Image.asset("assets/images/aossie_logo.png"),
                    ),
                    SizedBox(height: 0.018 * Get.height),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                          fontSize: 0.015 * Get.height + 0.03 * Get.width),
                    ),
                    SizedBox(height: 0.018 * Get.height),
                    Container(
                      height: 0.08 * Get.height,
                      child: TextFormField(
                        validator: (value) => value!.isValidEmail()
                            ? null
                            : "Enter Valid Email Address",
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: 0.0085 * Get.height + 0.017 * Get.width),
                        autocorrect: false,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.alternate_email,
                            size: 0.014 * Get.height + 0.029 * Get.width,
                          ),
                          labelText: "Email ID",
                        ),
                      ),
                    ),
                    SizedBox(height: 0.012 * Get.height),
                    Container(
                      height: 0.08 * Get.height,
                      child: Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordFieldVisible.value,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(
                              fontSize:
                                  0.0085 * Get.height + 0.017 * Get.width),
                          decoration: InputDecoration(
                            icon: Icon(
                              size: 0.014 * Get.height + 0.029 * Get.width,
                              Icons.lock_outline_rounded,
                            ),
                            labelText: "Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.isPasswordFieldVisible.value =
                                    !controller.isPasswordFieldVisible.value;
                              },
                              splashRadius: 0.024 * Get.height,
                              icon: Icon(
                                size: 0.014 * Get.height + 0.029 * Get.width,
                                controller.isPasswordFieldVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.018 * Get.height),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          //TODO: Navigate to forgot password screen
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize:
                                  0.0085 * Get.height + 0.017 * Get.width),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.018 * Get.height),
                    Obx(
                      () => ElevatedButton(
                        onPressed: () async {
                          if (!controller.isLoading.value) {
                            await controller.login();
                          }
                        },
                        child: controller.isLoading.value
                            ? Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  color: Colors.black,
                                  size: 0.024 * Get.height + 0.048 * Get.width,
                                ),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      0.024 * Get.width + 0.012 * Get.height,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 0.036 * Get.height),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            indent: 0.048 * Get.width,
                            endIndent: 0.024 * Get.width,
                            thickness: 0.0012 * Get.height,
                          ),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(
                              fontSize:
                                  0.0085 * Get.height + 0.017 * Get.width),
                        ),
                        Expanded(
                          child: Divider(
                            indent: 0.048 * Get.width,
                            endIndent: 0.024 * Get.width,
                            thickness: 0.0012 * Get.height,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.036 * Get.height),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFFFE0),
                      ),
                      onPressed: () async {
                        await controller.loginWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 0.036 * Get.height,
                            width: 0.072 * Get.width,
                            child: Image.asset("assets/images/google_icon.png"),
                          ),
                          SizedBox(
                            width: 0.024 * Get.width,
                          ),
                          Text(
                            'Login with Google',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 0.01 * Get.height + 0.021 * Get.width,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New to Resonate?",
                          style: TextStyle(
                              fontSize:
                                  0.017 * Get.width + 0.0085 * Get.height),
                        ),
                        SizedBox(
                          width: 0.012 * Get.width,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.emailController.clear();
                            controller.passwordController.clear();
                            Get.toNamed(AppRoutes.signup);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                                color: AppColor.yellowColor,
                                fontSize:
                                    0.017 * Get.width + 0.0085 * Get.height),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
