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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: <Widget>[
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                      "assets/images/aossie_logo.png")),
              const SizedBox(height: 15),
              Text(
                "Login",
                style: GoogleFonts.poppins(
                    fontSize: 26, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.alternate_email,
                    color: Colors.black54,
                  ),
                  labelText: "Email ID",
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor.greenColor, width: 2)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54)),
                ),
              ),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.black54,
                  ),
                  labelText: "Password",
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility_off_outlined,
                          color: Colors.black54)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor.greenColor, width: 2)),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54)),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    //TODO: Navigate to forgot password screen
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.greenColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                  minimumSize: const Size.fromHeight(45), // NEW
                ),
                onPressed: () async {
                  await controller.login();
                },
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
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
                  backgroundColor: Color(0xffF1F7F6),
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
                      height:30,width:30,
                        child: Image.asset("assets/images/google_icon.png")),
                    SizedBox(width: 10,),
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
              Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New to Resonate?  "),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(AppRoutes.signup);
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
