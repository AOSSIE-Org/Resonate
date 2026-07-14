import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/settings_notifier.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  void build() {}

  Future<void> logout() => ref.read(authRepositoryProvider).logout();
}
