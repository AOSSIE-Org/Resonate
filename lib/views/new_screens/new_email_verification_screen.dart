import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/views/new_widgets/new_loading_dialog.dart';

import '../../controllers/authentication_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/enums/message_type_enum.dart';
import '../../utils/ui_sizes.dart';
import '../widgets/snackbar.dart';

class NewEmailVerificationScreen extends StatelessWidget {
  NewEmailVerificationScreen({super.key});

  final controller = Get.find<AuthenticationController>();
  final emailVerifyController = Get.find<EmailVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
        width: double.maxFinite,
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: UiSizes.height_60,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your\nVerification Code",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(
                height: UiSizes.height_40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                    children: [
                      const TextSpan(
                        text: "We sent a 6-digit verification code to\n",
                      ),
                      TextSpan(
                        text: controller.authStateController.email,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: UiSizes.height_60,
              ),
              OtpTextField(
                autoFocus: true,
                numberOfFields: 6,
                showFieldAsBox: true,
                keyboardType: TextInputType.number,
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                borderWidth: 1,
                contentPadding: EdgeInsets.zero,
                borderColor: Colors.transparent,
                enabledBorderColor: Colors.transparent,
                focusedBorderColor: Theme.of(context).colorScheme.primary,
                // runs when every text-field is filled
                onSubmit: (String verificationCode) async {
                  newLoadingDialog(context);
                  emailVerifyController.isVerifying.value = true;
                  await emailVerifyController.verifyOTP(verificationCode);

                  if (emailVerifyController.responseVerify.response ==
                      '{"message":"null"}') {
                    String result =
                        await emailVerifyController.checkVerificationStatus();
                    if (result == "true") {
                      customSnackbar(
                        "Verification Complete",
                        "Congratulations you have verified your Email",
                        MessageType.success,
                      );
                      await emailVerifyController.setVerified();
                      if (emailVerifyController.responseSetVerified.response ==
                          '{"message":"null"}') {
                        emailVerifyController.isVerifying.value = false;

                        // Close loading dialog
                        Get.back();

                        controller.authStateController.setUserProfileData();
                        Get.offAllNamed(AppRoutes.tabview);
                      } else {
                        emailVerifyController.isVerifying.value = false;

                        // Close loading dialog
                        Get.back();

                        customSnackbar(
                          'Oops',
                          emailVerifyController.responseSetVerified.response,
                          MessageType.error,
                        );
                      }
                    } else {
                      emailVerifyController.isVerifying.value = false;

                      // Close loading dialog
                      Get.back();

                      customSnackbar(
                        "Verification Failed",
                        "OTP mismatch occurred please try again",
                        MessageType.error,
                      );
                    }
                  } else {
                    customSnackbar(
                      'Oops',
                      emailVerifyController.responseVerify.response,
                      MessageType.error,
                    );
                  }
                },
              ),
              SizedBox(
                height: UiSizes.height_60,
              ),
              Obx(
                () => (emailVerifyController.resendIsAllowed.value)
                    ? GestureDetector(
                        onTap: () {
                          emailVerifyController.resendIsAllowed.value = false;
                          emailVerifyController.sendOTP();
                          customSnackbar(
                            "OTP resent",
                            "Please check your mail for a new OTP.",
                            MessageType.info,
                          );
                        },
                        child: Text(
                          "Request a new code",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Request a new code in",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: UiSizes.width_10,
                            ),
                            child: CircularCountDownTimer(
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              isTimerTextShown: true,
                              isReverse: true,
                              onComplete: () {
                                emailVerifyController.resendIsAllowed.value =
                                    true;
                              },
                              width: 30,
                              height: 30,
                              duration: 30,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              fillColor: Theme.of(context).colorScheme.primary,
                              ringColor:
                                  Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          Text(
                            "seconds.",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
