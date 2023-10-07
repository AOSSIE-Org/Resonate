import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.find<AuthenticationController>();

  @override
  void initState() {
    controller.loginFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: UiSizes.height_765,
          padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_20, vertical: UiSizes.height_10),
          child: Form(
            key: controller.loginFormKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: UiSizes.height_765 - UiSizes.height_20,
                // minus 20 was added in order to avoid unnecessary scrolling when screen had required size
                child: Column(
                  children: <Widget>[
                    SizedBox(height: UiSizes.height_40),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Welcome",
                            style: TextStyle(fontSize: UiSizes.size_25),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  fontSize: UiSizes.size_70,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: UiSizes.height_15),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UiSizes.height_4),
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UiSizes.height_4),
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
                    SizedBox(height: UiSizes.height_20),
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
                    SizedBox(height: UiSizes.height_24_6),
                    AuthButtonWidget(
                      onPressed: () async {
                        await controller.loginWithGoogle();
                      },
                      logoPath: "assets/images/google_icon.png",
                      authText: "Login with Google",
                    ),
                    SizedBox(height: UiSizes.height_15),
                    AuthButtonWidget(
                      onPressed: () async {
                        await controller.loginWithGithub();
                      },
                      logoPath: AppImages.githubIconImage,
                      authText: "Login with Github",
                    ),
                    SizedBox(height: UiSizes.height_15),
                    Expanded(
                      child: Row(
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
