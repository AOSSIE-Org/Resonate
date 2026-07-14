import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/view/string_validators.dart';
import 'package:resonate/features/auth/view/widgets/password_strength_indicator.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/viewmodel/email_verify_notifier.dart';
import 'package:resonate/features/auth/viewmodel/password_strength_notifier.dart';
import 'package:resonate/features/auth/viewmodel/signup_form_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearAndReset() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    ref.read(signupFormProvider.notifier).reset();
    ref.read(passwordStrengthCheckerProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.watch(signupFormProvider);
    final authValue = ref.watch(authSessionProvider);
    final strength = ref.watch(passwordStrengthCheckerProvider);
    final emailVerifyState = ref.watch(emailVerifyProvider);

    ref.listen<AsyncValue>(authSessionProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => _showError(context, e, l10n),
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
                    SizedBox(height: UiSizes.height_20),
                    Text(
                      l10n.createAccount,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.passwordEmpty;
                        }
                        if (!value.isValidPassword()) {
                          return l10n.passwordRequirements;
                        }
                        return null;
                      },
                      obscureText: !formState.passwordVisible,
                      onChanged: (v) => ref
                          .read(passwordStrengthCheckerProvider.notifier)
                          .check(v),
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        hintText: l10n.password,
                        suffixIcon: Semantics(
                          label: formState.passwordVisible
                              ? l10n.hidePassword
                              : l10n.showPassword,
                          child: GestureDetector(
                            onTap: () => ref
                                .read(signupFormProvider.notifier)
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
                    SizedBox(height: UiSizes.height_10),
                    TextFormField(
                      validator: (value) =>
                          value!.isSamePassword(_passwordController.text)
                              ? null
                              : l10n.passwordsNotMatch,
                      controller: _confirmPasswordController,
                      obscureText: !formState.confirmPasswordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: l10n.confirmPassword,
                        suffixIcon: Semantics(
                          label: formState.confirmPasswordVisible
                              ? l10n.hidePassword
                              : l10n.showPassword,
                          child: GestureDetector(
                            onTap: () => ref
                                .read(signupFormProvider.notifier)
                                .toggleConfirmPasswordVisible(),
                            child: Container(
                              width: UiSizes.width_56,
                              color: Colors.transparent,
                              child: Icon(
                                formState.confirmPasswordVisible
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
                    SizedBox(height: UiSizes.height_20),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _passwordController.text.isNotEmpty,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        opacity:
                            _passwordController.text.isNotEmpty ? 1 : 0,
                        child: SizedBox(
                          height: UiSizes.height_45,
                          width: MediaQuery.of(context).size.width,
                          child: PasswordStrengthIndicator(
                            strength: strength,
                            minLengthLabel: l10n.passwordRequirements,
                            digitLabel: l10n.includeNumericDigit,
                            uppercaseLabel: l10n.includeUppercase,
                            lowercaseLabel: l10n.includeLowercase,
                            symbolLabel: l10n.includeSymbol,
                            verifiedLabel: l10n.passwordIsStrong,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_10),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: emailVerifyState.signupAllowed &&
                                !authValue.isLoading
                            ? () async {
                                if (!_formKey.currentState!.validate()) return;
                                final view = View.of(context);
                                final router = GoRouter.of(context);
                                ref
                                    .read(emailVerifyProvider.notifier)
                                    .blockSignup();
                                await ref.read(signupFormProvider.notifier).signup(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                if (!ref.read(authSessionProvider).hasError) {
                                  router.go(RoutePaths.onboarding);
                                  customSnackbar(
                                    l10n.signedUpSuccessfully,
                                    l10n.newAccountCreated,
                                    LogType.success,
                                  );
                                  SemanticsService.sendAnnouncement(
                                    view,
                                    l10n.newAccountCreated,
                                    TextDirection.ltr,
                                  );
                                }
                                ref
                                    .read(emailVerifyProvider.notifier)
                                    .allowSignup();
                              }
                            : null,
                        child: authValue.isLoading
                            ? Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: UiSizes.size_40,
                                ),
                              )
                            : Text(l10n.signUp),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.alreadyHaveAccount),
                    GestureDetector(
                      onTap: () {
                        _clearAndReset();
                        context.go(RoutePaths.login);
                      },
                      child: Text(
                        l10n.login,
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

  void _showError(BuildContext context, Object error, AppLocalizations l10n) {
    final message = switch (error) {
      AuthFailureUserAlreadyExists() => l10n.tryAgain,
      AuthFailure() => error.toString(),
      _ => error.toString(),
    };
    customSnackbar(l10n.oops, message, LogType.error);
    SemanticsService.sendAnnouncement(View.of(context),message, TextDirection.ltr);
  }
}
