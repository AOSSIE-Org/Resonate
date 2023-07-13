import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';

class UpdateEmailScreen extends StatelessWidget {
  UpdateEmailScreen({Key? key}) : super(key: key);

  final controller = Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Image.asset("assets/images/aossie_logo.png"),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(161, 112, 106, 80),
                          Color.fromARGB(232, 60, 58, 52)
                        ])),
                    child: const Center(
                        child: Text(
                      "Email Updation",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    const Text('Please enter the New Email',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 40),
                    Form(
                      key: controller.updateEmailFormKey,
                      child: TextFormField(
                        validator: (value) => value!.isValidEmail()
                            ? null
                            : "Enter Valid Email Address",
                        controller: controller.updateEmailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.alternate_email),
                          labelText: "New Email ID",
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Obx(
                      () => ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: controller.isUpdateAllowed.value
                                  ? MaterialStateProperty.all(
                                      AppColor.yellowColor)
                                  : MaterialStateProperty.all(
                                      const Color.fromARGB(255, 74, 74, 74))),
                          onPressed: controller.isUpdateAllowed.value
                              ? () async {
                                  if (controller
                                      .updateEmailFormKey.currentState!
                                      .validate()) {
                                    controller.isUpdateAllowed.value = false;
                                    if (controller.authStateController.email !=
                                        controller.updateEmailController.text) {
                                      await controller.updateEmail();
                                      if (controller.status == 'completed') {
                                        controller.authStateController.email =
                                            controller
                                                .updateEmailController.text;
                                        controller.sendOTP();
                                        controller.resendIsAllowed.value =
                                            false;
                                        Get.toNamed(
                                            AppRoutes.emailVerification);
                                      } else {
                                        Get.snackbar("Oops",
                                            "A user with the same email already exists");
                                      }
                                    } else {
                                      Get.snackbar('Same Email',
                                          'Your updated email was the same as previous');
                                      Get.toNamed(AppRoutes.emailVerification);
                                    }
                                    controller.isUpdateAllowed.value = true;
                                  }
                                }
                              : null,
                          child: controller.isUpdateAllowed.value
                              ? const Text(
                                  "Update Email",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              : Center(
                                  child: LoadingAnimationWidget
                                      .horizontalRotatingDots(
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // controller.isVerifying.value
        //     ? BackdropFilter(
        //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //         child: Center(
        //             child: LoadingAnimationWidget.threeRotatingDots(
        //                 color: Colors.amber, size: Get.pixelRatio * 20)),
        //       )
        //     : const SizedBox(),
      ]),
    ));
  }
}
