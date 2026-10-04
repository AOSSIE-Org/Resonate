import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final authController = Get.find<AuthenticationController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _extractParam(String key) {
    if (Get.parameters.containsKey(key) &&
        Get.parameters[key] != null &&
        Get.parameters[key]!.trim().isNotEmpty) {
      return Get.parameters[key]!.trim();
    }
    if (Get.arguments is Map) {
      final val = (Get.arguments as Map)[key];
      if (val != null && val.toString().trim().isNotEmpty) {
        return val.toString().trim();
      }
    }
    return null;
  }

  String? get userId => _extractParam('userId');
  String? get secret => _extractParam('secret');
  bool get isLinkValid => userId != null && secret != null;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!isLinkValid) {
      customSnackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.invalidOrMissingResetLink,
        LogType.error,
      );
      SemanticsService.announce(
        AppLocalizations.of(context)!.invalidOrMissingResetLink,
        TextDirection.ltr,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      await authController.confirmPasswordReset(
        userId: userId!,
        secret: secret!,
        newPassword: _passwordController.text,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.resetPassword)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: UiSizes.width_20,
              vertical: UiSizes.height_20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.enterNewPassword,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: UiSizes.height_20),
                  if (!isLinkValid)
                    Container(
                      margin: EdgeInsets.only(bottom: UiSizes.height_20),
                      padding: EdgeInsets.symmetric(
                        horizontal: UiSizes.width_16,
                        vertical: UiSizes.height_12,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: colorScheme.error),
                          SizedBox(width: UiSizes.width_10),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.invalidOrMissingResetLink,
                              style: TextStyle(
                                color: colorScheme.onErrorContainer,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, size: 23),
                      labelText: AppLocalizations.of(context)!.newPassword,
                      suffixIcon: Semantics(
                        label: _isPasswordVisible
                            ? AppLocalizations.of(context)!.hidePassword
                            : AppLocalizations.of(context)!.showPassword,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.passwordEmpty;
                      }
                      if (value.length < 8) {
                        return AppLocalizations.of(context)!.passwordShort;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: UiSizes.height_16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline, size: 23),
                      labelText: AppLocalizations.of(context)!.confirmPassword,
                      suffixIcon: Semantics(
                        label: _isConfirmPasswordVisible
                            ? AppLocalizations.of(context)!.hidePassword
                            : AppLocalizations.of(context)!.showPassword,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.passwordEmpty;
                      }
                      if (value != _passwordController.text) {
                        return AppLocalizations.of(context)!.passwordsNotMatch;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: UiSizes.height_30),
                  SizedBox(
                    width: double.maxFinite,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : _submit,
                        child: authController.isLoading.value
                            ? Center(
                                child:
                                    LoadingAnimationWidget.horizontalRotatingDots(
                                      color: colorScheme.onPrimary,
                                      size: UiSizes.size_40,
                                    ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.setNewPassword,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
