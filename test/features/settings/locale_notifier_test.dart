import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/settings/viewmodel/locale_notifier.dart';
import 'package:resonate/utils/constants.dart';

import '../../helpers/test_root_container.dart';

// Records writes to the secure storage channel for assertions.
const _storageChannel = MethodChannel(
  'plugins.it_nomads.com/flutter_secure_storage',
);

void main() {
  setUp(stubFlutterSecureStorageChannel);

  test('build returns the default locale from languageLocale global', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final locale = container.read(appLocaleProvider);

    expect(locale, Locale(languageLocale));
  });

  test('setLocale updates state to Locale(iso)', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(appLocaleProvider.notifier).setLocale('fr');

    expect(container.read(appLocaleProvider), const Locale('fr'));
  });

  test('setLocale writes the iso to secure storage under languageLocale', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_storageChannel, (call) async {
      calls.add(call);
      return null;
    });

    await container.read(appLocaleProvider.notifier).setLocale('es');

    final write = calls.firstWhere((c) => c.method == 'write');
    final args = write.arguments as Map;
    expect(args['key'], 'languageLocale');
    expect(args['value'], 'es');
  });

  test('keepAlive state is retained across reads', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(appLocaleProvider.notifier).setLocale('de');

    expect(container.read(appLocaleProvider), const Locale('de'));
    expect(container.read(appLocaleProvider), const Locale('de'));
  });
}
