import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/locale_notifier.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale build() => Locale(languageLocale);

  Future<void> setLocale(String isoCode) async {
    state = Locale(isoCode);
    await const FlutterSecureStorage().write(
      key: "languageLocale",
      value: isoCode,
    );
  }
}
