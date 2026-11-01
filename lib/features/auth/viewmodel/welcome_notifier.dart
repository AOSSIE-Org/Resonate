import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/welcome_notifier.g.dart';


@riverpod
class Welcome extends _$Welcome {
  @override
  void build() {}

  Future<void> continueWithGoogle() =>
      ref.read(authRepositoryProvider).loginWithGoogle();

  Future<void> continueWithGithub() =>
      ref.read(authRepositoryProvider).loginWithGithub();
}
