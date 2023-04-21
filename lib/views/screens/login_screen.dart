import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
              height: MediaQuery.of(context).size.height*0.9,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(children: <Widget>[
                SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.asset("assets/images/aossie_logo.png")),
                const SizedBox(height: 15),
                Text(
                  "Welcome Back",
                  style: GoogleFonts.poppins(
                      fontSize: 25, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.alternate_email,
                      color: AppColor.yellowColor,
                    ),
                    labelText: "Email ID",
                    floatingLabelStyle: TextStyle(color: AppColor.yellowColor),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColor.yellowColor, width: 2)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white60)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordFieldVisible.value,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColor.yellowColor,
                      ),
                      labelText: "Password",
                      floatingLabelStyle:
                          TextStyle(color: AppColor.yellowColor),
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller.isPasswordFieldVisible.value =
                                !controller.isPasswordFieldVisible.value;
                          },
                          splashRadius: 20,
                          icon: Icon(
                              controller.isPasswordFieldVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColor.yellowColor)),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor.yellowColor, width: 2)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white60)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      //TODO: Navigate to forgot password screen
                    },
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.poppins(
                        color: AppColor.yellowColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.yellowColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                      minimumSize: const Size.fromHeight(45), // NEW
                    ),
                    onPressed: () async {
                      await controller.login();
                    },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: AppColor.greenColor)
                        : Text(
                            'Login',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(children: const <Widget>[
                  Expanded(
                      child: Divider(
                    indent: 20.0,
                    endIndent: 10.0,
                    thickness: 1,
                  )),
                  Text("OR"),
                  Expanded(
                      child: Divider(
                    indent: 10.0,
                    endIndent: 20.0,
                    thickness: 1,
                  )),
                ]),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFFFFE0),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    minimumSize: const Size.fromHeight(45), // NEW
                  ),
                  onPressed: () async {
                    await controller.loginWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/images/google_icon.png")),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Login with Google',
                        style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New to Resonate?  "),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(AppRoutes.signup);
                      },
                      child: Text(
                        "Register",
                        style: GoogleFonts.poppins(
                          color: AppColor.yellowColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
