import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text("Signup"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Center(
            child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/13849023?s=280&v=4"),
                  ),
                  const SizedBox(height: 15),
                  const Text("Welcome", style: TextStyle(fontSize: 25)),
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: (){
                          Get.offNamed(AppRoutes.login);
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async{
                      await controller.signup();
                    },
                    child: const Text("Signup"),
                  ),
                  const SizedBox(height: 50),
                  const Text("OR"),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.loginWithGoogle();
                    },
                    child: const Text("Signup With Google"),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
