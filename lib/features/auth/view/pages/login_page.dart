import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/view/string_validators.dart';
import 'package:resonate/features/auth/viewmodel/login_form_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearAndReset() {
    _emailController.clear();
    _passwordController.clear();
    ref.read(loginFormProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.watch(loginFormProvider);
    final authValue = ref.watch(authSessionProvider);

    // Surface AuthFailure errors as snackbars.
    ref.listen<AsyncValue>(authSessionProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => _showAuthError(context, e, l10n),
      );
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _clearAndReset(),
      child: Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: UiSizes.height_60),
                    Text(
                      l10n.login,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: UiSizes.height_40),
                    TextFormField(
                      validator: (value) => value!.isValidEmail()
                          ? null
                          : l10n.enterValidEmailAddress,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(hintText: l10n.email),
                    ),
                    SizedBox(height: UiSizes.height_10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !formState.passwordVisible,
                      validator: (value) =>
                          value!.isEmpty ? l10n.passwordEmpty : null,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: l10n.password,
                        suffixIcon: Semantics(
                          label: formState.passwordVisible
                              ? l10n.hidePassword
                              : l10n.showPassword,
                          child: GestureDetector(
                            onTap: () => ref
                                .read(loginFormProvider.notifier)
                                .togglePasswordVisible(),
                            child: Container(
                              width: UiSizes.width_56,
                              color: Colors.transparent,
                              child: Icon(
                                formState.passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_30),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: authValue.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await ref.read(loginFormProvider.notifier).login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                  if (!ref.read(authSessionProvider).hasError) {
                                    _emailController.clear();
                                    _passwordController.clear();
                                  }
                                }
                              },
                        child: authValue.isLoading
                            ? Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: UiSizes.size_40,
                                ),
                              )
                            : Text(l10n.login),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_40),
                    GestureDetector(
                      onTap: () => context.go(RoutePaths.forgotPassword),
                      child: Text(
                        l10n.forgotPassword,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.newToResonate),
                    GestureDetector(
                      onTap: () {
                        _clearAndReset();
                        context.go(RoutePaths.signup);
                      },
                      child: Text(
                        l10n.register,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAuthError(BuildContext context, Object error, AppLocalizations l10n) {
    final (title, message) = switch (error) {
      AuthFailureInvalidCredentials() => (
          l10n.tryAgain,
          l10n.incorrectEmailOrPassword,
        ),
      AuthFailurePasswordTooShort() => (l10n.tryAgain, l10n.passwordShort),
      AuthFailure() => (l10n.oops, error.toString()),
      _ => (l10n.oops, error.toString()),
    };
    customSnackbar(title, message, LogType.error);
    SemanticsService.sendAnnouncement(View.of(context),message, TextDirection.ltr);
  }
}
