import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';

import '../../controllers/authentication_controller.dart';
import '../../controllers/email_verify_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/enums/log_type.dart';
import '../../utils/ui_sizes.dart';
import '../widgets/snackbar.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

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
              SizedBox(height: UiSizes.height_10),
              MergeSemantics(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.enterVerificationCode,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(
                                context,
                              )!.verificationCodeSent,
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
                  ],
                ),
              ),
              SizedBox(height: UiSizes.height_60),
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
                  loadingDialog(context);
                  emailVerifyController.isVerifying.value = true;
                  await emailVerifyController.verifyOTP(verificationCode);

                  if (emailVerifyController.responseVerify.responseBody ==
                      '{"message":"null"}') {
                    String result = await emailVerifyController
                        .checkVerificationStatus();
                    if (result == "true") {
                      customSnackbar(
                        AppLocalizations.of(context)!.verificationComplete,
                        AppLocalizations.of(
                          context,
                        )!.congratulationsEmailVerified,
                        LogType.success,
                      );

                      SemanticsService.announce(
                        AppLocalizations.of(
                          context,
                        )!.congratulationsEmailVerified,
                        TextDirection.ltr,
                      );
                      await emailVerifyController.setVerified();
                      if (emailVerifyController
                              .responseSetVerified
                              .responseBody ==
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
                          AppLocalizations.of(context)!.oops,
                          emailVerifyController
                              .responseSetVerified
                              .responseBody,
                          LogType.error,
                        );

                        SemanticsService.announce(
                          emailVerifyController
                              .responseSetVerified
                              .responseBody,
                          TextDirection.ltr,
                        );
                      }
                    } else {
                      emailVerifyController.isVerifying.value = false;

                      // Close loading dialog
                      Get.back();
                      customSnackbar(
                        AppLocalizations.of(context)!.verificationFailed,
                        AppLocalizations.of(context)!.otpMismatchError,
                        LogType.error,
                      );

                      SemanticsService.announce(
                        AppLocalizations.of(context)!.otpMismatchError,
                        TextDirection.ltr,
                      );
                    }
                  } else {
                    customSnackbar(
                      AppLocalizations.of(context)!.oops,
                      emailVerifyController.responseVerify.responseBody,
                      LogType.error,
                    );

                    SemanticsService.announce(
                      emailVerifyController.responseVerify.responseBody,
                      TextDirection.ltr,
                    );
                  }
                },
              ),
              SizedBox(height: UiSizes.height_60),
              Obx(
                () => (emailVerifyController.resendIsAllowed.value)
                    ? GestureDetector(
                        onTap: () {
                          emailVerifyController.resendIsAllowed.value = false;
                          emailVerifyController.sendOTP();
                          customSnackbar(
                            AppLocalizations.of(context)!.otpResent,
                            AppLocalizations.of(context)!.otpResentMessage,
                            LogType.info,
                          );

                          SemanticsService.announce(
                            AppLocalizations.of(context)!.otpResentMessage,
                            TextDirection.ltr,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.requestNewCode,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : MergeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.requestNewCodeIn,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: UiSizes.width_10,
                              ),
                              child: CircularCountDownTimer(
                                textStyle: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
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
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                fillColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                ringColor: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.seconds,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
