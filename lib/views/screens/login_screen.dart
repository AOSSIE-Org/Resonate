import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/auth_button.dart';
import 'package:resonate/controllers/version_check_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.find<AuthenticationController>();
  var themeController = Get.find<ThemeController>();
  var versionCheckController = Get.put(VersionCheckController());

  late String appUpgradeMsg;
  late Future<VersionCheckResult> versionCheckObject;

  @override
  void initState() {
    controller.loginFormKey = GlobalKey<FormState>();
    super.initState();

    appUpgradeMsg = versionCheckController.appUpgradeMsg;
    versionCheckObject = versionCheckController.minimumVersionCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 780,
            padding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_20, vertical: UiSizes.height_10),
            child: FutureBuilder<bool>(
              future: versionCheckObject.then((value) {
                return value.versionValid;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  bool shouldRenderWidget1 = snapshot.data ?? false;
                  return shouldRenderWidget1
                      ? LoginFormWidget(
                          controller: controller,
                          themeController: themeController)
                      : UpdateAppWidget(appUpgradeMsg: appUpgradeMsg);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateAppWidget extends StatelessWidget {
  const UpdateAppWidget({
    super.key,
    required this.appUpgradeMsg,
  });

  final String appUpgradeMsg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        height: 400,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/aossie_logo.png',
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/resonate_logo.png',
                  height: 100,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                appUpgradeMsg,
                style: TextStyle(color: Colors.amberAccent),
              )),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amberAccent, width: 5)),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/play_store.png',
                  height: 30,
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Update App',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AuthenticationController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: UiSizes.width_140,
            height: UiSizes.height_140,
            child: Image.asset(AppImages.aossieLogoImage),
          ),
          SizedBox(height: UiSizes.height_15),
          Text(
            "Welcome Back",
            style: TextStyle(fontSize: UiSizes.size_25, color: Colors.amber),
          ),
          SizedBox(height: UiSizes.height_15),
          Padding(
            padding: EdgeInsets.symmetric(vertical: UiSizes.height_4),
            child: TextFormField(
              validator: (value) =>
                  value!.isValidEmail() ? null : "Enter Valid Email Address",
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                  fontSize: UiSizes.size_14,
                  color: themeController.loadTheme() == 'dark'
                      ? Colors.white
                      : Colors.black),
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
                          : Colors.black)),
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
                style: TextStyle(
                    fontSize: UiSizes.size_14,
                    color: themeController.loadTheme() == 'dark'
                        ? Colors.white
                        : Colors.black),
                decoration: InputDecoration(
                  icon: Icon(
                    size: UiSizes.size_23,
                    Icons.lock_outline_rounded,
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                      color: themeController.loadTheme() == 'dark'
                          ? Colors.white
                          : Colors.black),
                  errorStyle: TextStyle(
                    fontSize: UiSizes.size_14,
                  ),
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
            padding: EdgeInsets.symmetric(vertical: UiSizes.height_15),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                //TODO: Navigate to forgot password screen
              },
              child: Text(
                "Forgot Password?",
                style:
                    TextStyle(color: Colors.amber, fontSize: UiSizes.size_14),
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
                      child: LoadingAnimationWidget.horizontalRotatingDots(
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
          SizedBox(height: UiSizes.height_16),
          AuthButtonWidget(
            onPressed: () async {
              await controller.loginWithGithub();
            },
            logoPath: "assets/images/github_icon.png",
            authText: "Login with Github",
          ),
          SizedBox(
            height: UiSizes.height_40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New to Resonate?",
                style: TextStyle(
                    fontSize: UiSizes.size_14,
                    color: themeController.loadTheme() == 'dark'
                        ? Colors.white
                        : Colors.black),
              ),
              SizedBox(
                width: UiSizes.width_5,
              ),
              GestureDetector(
                onTap: () {
                  controller.emailController.clear();
                  controller.passwordController.clear();
                  controller.confirmPasswordController.clear();
                  Get.toNamed(AppRoutes.signup);
                },
                child: Text(
                  "Register",
                  style:
                      TextStyle(color: Colors.amber, fontSize: UiSizes.size_14),
                ),
              )
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
