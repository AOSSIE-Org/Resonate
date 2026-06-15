import 'dart:convert';

import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/email_verify_notifier.g.dart';

class EmailVerifyState {
  const EmailVerifyState({
    this.verificationId,
    this.canResend = false,
    this.signupAllowed = true,
  });

  // The most recent verification ID returned by verifyOtp.
  final String? verificationId;
  final bool canResend;
  final bool signupAllowed;

  EmailVerifyState copyWith({
    String? verificationId,
    bool? canResend,
    bool? signupAllowed,
  }) =>
      EmailVerifyState(
        verificationId: verificationId ?? this.verificationId,
        canResend: canResend ?? this.canResend,
        signupAllowed: signupAllowed ?? this.signupAllowed,
      );
}

@riverpod
class EmailVerify extends _$EmailVerify {
  @override
  EmailVerifyState build() => const EmailVerifyState();

  Future<({bool sent, String responseBody})> sendOtp({
    required String email,
  }) async {
    final result = await ref.read(authRepositoryProvider).sendOtp(email: email);
    final sent = _otpResponseLooksSuccessful(result.responseBody);
    if (sent) {
      state = state.copyWith(canResend: false);
    }
    return (sent: sent, responseBody: result.responseBody);
  }
  
  bool _otpResponseLooksSuccessful(String body) {
    try {
      final decoded = jsonDecode(body);
      return decoded is Map &&
          decoded['message']?.toString().toLowerCase() == 'mail sent';
    } catch (_) {
      return false;
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String userOtp,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .verifyOtp(email: email, userOtp: userOtp);
    state = state.copyWith(verificationId: result.verificationId);
  }

  Future<String?> checkVerificationStatus() async {
    final id = state.verificationId;
    if (id == null) return null;
    return ref
        .read(authRepositoryProvider)
        .checkVerificationStatus(verificationId: id);
  }

  Future<void> markVerified({required String uid}) async {
    await ref.read(authRepositoryProvider).markUserVerified(uid: uid);
    await ref.read(authProvider.notifier).refresh();
  }

  Future<String> updateEmail({
    required String uid,
    required String newEmail,
  }) async {
    final status = await ref
        .read(authRepositoryProvider)
        .updateEmail(uid: uid, newEmail: newEmail);
    await ref.read(authProvider.notifier).refresh();
    return status;
  }

  void allowResend() {
    state = state.copyWith(canResend: true);
  }

  void allowSignup() {
    state = state.copyWith(signupAllowed: true);
  }

  void blockSignup() {
    state = state.copyWith(signupAllowed: false);
  }
}
