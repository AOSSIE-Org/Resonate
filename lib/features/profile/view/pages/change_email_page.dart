import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/auth/view/string_validators.dart';
import 'package:resonate/features/profile/model/change_email_state.dart';
import 'package:resonate/features/profile/viewmodel/change_email_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class ChangeEmailPage extends ConsumerStatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ConsumerState<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends ConsumerState<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;
    final view = View.of(context);

    final status = await ref.read(changeEmailProvider.notifier).changeEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;

    final (title, message, type) = switch (status) {
      ChangeEmailStatus.success => (
          l10n.emailChanged,
          l10n.emailChangeSuccess,
          LogType.success,
        ),
      ChangeEmailStatus.emailExists => (
          l10n.oops,
          l10n.emailExists,
          LogType.error,
        ),
      ChangeEmailStatus.invalidCredentials => (
          l10n.tryAgain,
          l10n.incorrectEmailOrPassword,
          LogType.error,
        ),
      ChangeEmailStatus.passwordTooShort => (
          l10n.tryAgain,
          l10n.passwordShort,
          LogType.error,
        ),
      ChangeEmailStatus.failed => (
          l10n.failed,
          l10n.emailChangeFailed,
          LogType.error,
        ),
    };
    customSnackbar(title, message, type);
    SemanticsService.sendAnnouncement(view, message, TextDirection.ltr);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(changeEmailProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(l10n.changeEmail)),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: UiSizes.height_20,
            horizontal: UiSizes.width_20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) => value!.isValidEmail()
                      ? null
                      : l10n.enterValidEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                    labelText: l10n.newEmail,
                  ),
                ),
                SizedBox(height: UiSizes.height_20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !state.passwordVisible,
                  validator: (value) =>
                      value! == "" ? l10n.passwordEmpty : null,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    labelText: l10n.currentPassword,
                    suffixIcon: Semantics(
                      label: state.passwordVisible
                          ? l10n.hidePassword
                          : l10n.showPassword,
                      child: GestureDetector(
                        onTap: () => ref
                            .read(changeEmailProvider.notifier)
                            .togglePasswordVisible(),
                        child: Container(
                          width: UiSizes.width_56,
                          color: Colors.transparent,
                          child: Icon(
                            state.passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: UiSizes.height_30),
                Text(l10n.emailChangeInfo),
                SizedBox(height: UiSizes.height_30),
                MergeSemantics(
                  child: Column(
                    children: [
                      Text(
                        l10n.oauthUsersMessage,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(l10n.oauthUsersEmailChangeInfo),
                    ],
                  ),
                ),
                SizedBox(height: UiSizes.height_30),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed:
                        state.isLoading ? null : () async => _submit(l10n),
                    child: state.isLoading
                        ? Center(
                            child:
                                LoadingAnimationWidget.horizontalRotatingDots(
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: UiSizes.size_40,
                            ),
                          )
                        : Text(l10n.changeEmail),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
