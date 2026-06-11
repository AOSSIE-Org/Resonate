import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/delete_account_notifier.g.dart';

// Not Implemented as it never was
@riverpod
class DeleteAccount extends _$DeleteAccount {
  @override
  bool build() => false;

  void setButtonActive(bool value) => state = value;
}
