import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/auth/viewmodel/email_verify_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class EmailVerificationPage extends ConsumerWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final auth = ref.watch(authProvider);
    final verifyState = ref.watch(emailVerifyProvider);
    final email = auth.value?.userOrNull?.email ?? '';

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
                        l10n.enterVerificationCode,
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
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          children: [
                            TextSpan(text: l10n.verificationCodeSent),
                            TextSpan(
                              text: email,
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
                onSubmit: (code) =>
                    _handleSubmit(context, ref, code, email, l10n),
              ),
              SizedBox(height: UiSizes.height_60),
              if (verifyState.canResend)
                GestureDetector(
                  onTap: () async {
                    final view = View.of(context);
                    try {
                      final result = await ref
                          .read(emailVerifyProvider.notifier)
                          .sendOtp(email: email);
                      if (result.sent) {
                        customSnackbar(l10n.otpResent, l10n.otpResentMessage,
                            LogType.info);
                        SemanticsService.sendAnnouncement(view,
                            l10n.otpResentMessage, TextDirection.ltr);
                      } else {
                        customSnackbar(
                            l10n.oops, result.responseBody, LogType.error);
                      }
                    } catch (e) {
                      customSnackbar(l10n.oops, e.toString(), LogType.error);
                    }
                  },
                  child: Text(
                    l10n.requestNewCode,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                MergeSemantics(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.requestNewCodeIn,
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
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          isTimerTextShown: true,
                          isReverse: true,
                          onComplete: () => ref
                              .read(emailVerifyProvider.notifier)
                              .allowResend(),
                          width: UiSizes.size_30,
                          height: UiSizes.size_30,
                          duration: 30,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          fillColor: Theme.of(context).colorScheme.primary,
                          ringColor: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      Text(
                        l10n.seconds,
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

  Future<void> _handleSubmit(
    BuildContext context,
    WidgetRef ref,
    String code,
    String email,
    AppLocalizations l10n,
  ) async {
    final view = View.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final router = GoRouter.of(context);

    _showLoadingDialog(context);
    final notifier = ref.read(emailVerifyProvider.notifier);
    final uid = ref.read(authProvider).value?.userOrNull?.uid;

    void announce(String message) {
      SemanticsService.sendAnnouncement(view, message, TextDirection.ltr);
    }

    try {
      await notifier.verifyOtp(email: email, userOtp: code);
      final status = await notifier.checkVerificationStatus();
      if (status != 'true') {
        navigator.pop();
        customSnackbar(l10n.verificationFailed, l10n.otpMismatch, LogType.error);
        announce(l10n.otpMismatch);
        return;
      }

      if (uid != null) {
        await notifier.markVerified(uid: uid);
      }
      navigator.pop();
      customSnackbar(
        l10n.verificationComplete,
        l10n.verificationCompleteMessage,
        LogType.success,
      );
      announce(l10n.verificationCompleteMessage);
      router.go(RoutePaths.tabview);
    } catch (e) {
      navigator.pop();
      customSnackbar(l10n.oops, e.toString(), LogType.error);
      announce(e.toString());
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Theme.of(context).colorScheme.primary,
          size: UiSizes.width_40,
        ),
      ),
    );
  }
}
