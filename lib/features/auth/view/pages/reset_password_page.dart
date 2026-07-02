import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/viewmodel/reset_password_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, required this.userId, required this.secret});

  final String? userId;
  final String? secret;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Bad link → bounce back to welcome.
    if (widget.userId == null || widget.secret == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RoutePaths.welcome);
      });
      return const SizedBox.shrink();
    }

    ref.listen<AsyncValue<bool>>(resetPasswordProvider, (prev, next) {
      next.whenOrNull(
        data: (ok) {
          if (ok && context.mounted) {
            customSnackbar(l10n.success, l10n.passwordResetSent, LogType.success);
            context.go(RoutePaths.login);
          }
        },
        error: (e, _) {
          customSnackbar(l10n.error, e.toString(), LogType.error);
          SemanticsService.sendAnnouncement(View.of(context),e.toString(), TextDirection.ltr);
        },
      );
    });

    final resetState = ref.watch(resetPasswordProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetPassword)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(UiSizes.width_25),
              child: Text(
                l10n.enterNewPassword,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: UiSizes.size_20),
              ),
            ),
            SizedBox(height: UiSizes.height_10),
            Container(
              width: UiSizes.width_300,
              padding: EdgeInsets.symmetric(vertical: UiSizes.height_10),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(fontSize: UiSizes.size_14),
                decoration: InputDecoration(
                  icon: Icon(Icons.lock, size: UiSizes.size_23),
                  labelText: l10n.newPassword,
                ),
              ),
            ),
            SizedBox(height: UiSizes.height_10),
            MaterialButton(
              onPressed: resetState.isLoading
                  ? null
                  : () => ref.read(resetPasswordProvider.notifier).resetPassword(
                        userId: widget.userId!,
                        secret: widget.secret!,
                        newPassword: _passwordController.text,
                      ),
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                l10n.setNewPassword,
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
