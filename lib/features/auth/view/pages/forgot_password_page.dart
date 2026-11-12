import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/view/string_validators.dart';
import 'package:resonate/features/auth/viewmodel/forgot_password_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AsyncValue<bool>>(forgotPasswordProvider, (prev, next) {
      next.whenOrNull(
        data: (sent) {
          if (sent) {
            customSnackbar(
              l10n.success,
              l10n.passwordResetSent,
              LogType.success,
            );
            SemanticsService.sendAnnouncement(
              View.of(context),
              l10n.passwordResetSent,
              TextDirection.ltr,
            );
          }
        },
        error: (e, _) {
          customSnackbar(l10n.error, e.toString(), LogType.error);
          SemanticsService.sendAnnouncement(
            View.of(context),
            e.toString(),
            TextDirection.ltr,
          );
        },
      );
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UiSizes.width_20,
          vertical: UiSizes.height_20,
        ),
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: UiSizes.height_60),
              MergeSemantics(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.forgotPassword,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(l10n.forgotPasswordMessage),
                    ),
                  ],
                ),
              ),
              SizedBox(height: UiSizes.height_20),
              TextFormField(
                controller: _emailController,
                validator: (value) =>
                    value!.isValidEmail() ? null : l10n.enterValidEmailAddress,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(hintText: l10n.email),
              ),
              SizedBox(height: UiSizes.height_30),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref
                          .read(forgotPasswordProvider.notifier)
                          .sendRecoveryEmail(
                            email: _emailController.text,
                            redirectUrl: 'https://localhost/reset-password',
                          );
                    }
                  },
                  child: Text(l10n.next),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
