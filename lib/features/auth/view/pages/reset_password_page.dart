import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/viewmodel/reset_password_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
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
              padding: const EdgeInsets.all(24.0),
              child: Text(
                l10n.enterNewPassword,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock, size: 23),
                  labelText: l10n.newPassword,
                ),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              onPressed: resetState.isLoading
                  ? null
                  : () => ref.read(resetPasswordProvider.notifier).resetPassword(
                        userId: widget.userId!,
                        secret: widget.secret!,
                        newPassword: _passwordController.text,
                      ),
              color: Colors.amber,
              child: Text(
                l10n.setNewPassword,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
