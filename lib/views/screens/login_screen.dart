import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: UiSizes.height_780,
              padding: EdgeInsets.symmetric(
                  horizontal: UiSizes.width_20, vertical: UiSizes.height_10),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: UiSizes.width_180,
                      height: UiSizes.height_180,
                      child: Image.asset("assets/images/aossie_logo.png"),
                    ),
                    SizedBox(height: UiSizes.height_15),
                    Text(
                      "Welcome Back",
                      style: TextStyle(fontSize: UiSizes.size_24_6),
                    ),
                    SizedBox(height: UiSizes.height_15),
                    Container(
                      height: UiSizes.height_65_7,
                      child: TextFormField(
                        validator: (value) => value!.isValidEmail()
                            ? null
                            : "Enter Valid Email Address",
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: UiSizes.size_14),
                        autocorrect: false,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.alternate_email,
                            size: UiSizes.size_23,
                          ),
                          errorStyle: TextStyle(fontSize: UiSizes.size_14),
                          labelText: "Email ID",
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_10),
                    Container(
                      height: UiSizes.height_65_7,
                      child: Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordFieldVisible.value,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(fontSize: UiSizes.size_14),
                          decoration: InputDecoration(
                            icon: Icon(
                              size: UiSizes.size_23,
                              Icons.lock_outline_rounded,
                            ),
                            labelText: "Password",
                            errorStyle: TextStyle(fontSize: UiSizes.size_14),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.isPasswordFieldVisible.value =
                                    !controller.isPasswordFieldVisible.value;
                              },
                              splashRadius: UiSizes.height_19_7,
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
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: UiSizes.height_15),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          //TODO: Navigate to forgot password screen
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.yellow, fontSize: UiSizes.size_14),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_15),
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
                                  size: UiSizes.size_40,
                                ),
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: UiSizes.size_19,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_29_6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            indent: UiSizes.width_20,
                            endIndent: UiSizes.width_10,
                            thickness: UiSizes.height_1,
                          ),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(fontSize: UiSizes.size_14),
                        ),
                        Expanded(
                          child: Divider(
                            indent: UiSizes.width_20,
                            endIndent: UiSizes.width_10,
                            thickness: UiSizes.height_1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: UiSizes.height_29_6),
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
                            height: UiSizes.height_29_6,
                            width: UiSizes.width_29_6,
                            child: Image.asset("assets/images/google_icon.png"),
                          ),
                          SizedBox(
                            width: UiSizes.width_10,
                          ),
                          Text(
                            'Login with Google',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: UiSizes.size_17,
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
                          style: TextStyle(fontSize: UiSizes.size_14),
                        ),
                        SizedBox(
                          width: UiSizes.width_5,
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
                                fontSize: UiSizes.size_14),
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
