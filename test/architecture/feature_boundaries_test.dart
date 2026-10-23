import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Test for achitectural testing
const _sharedProviders = <String, String>{
  // App-wide config/state observed by many screens
  'features/theme/viewmodel/theme_notifier.dart':
      'app-wide theme + default-avatar URL config',
  'features/shell/viewmodel/tabview_notifier.dart':
      'app-wide bottom-nav index + deep-link state',
};

void main() {
  test('no file imports another feature\'s screen view model', () {
    final importPattern = RegExp(
      r'''import\s+['"]package:resonate/(features/(\w+)/viewmodel/[^'"]+)['"]''',
    );
    final featureOf = RegExp(r'lib/features/(\w+)/');
    final violations = <String>[];

    for (final dir in ['lib/features', 'lib/shared', 'lib/routes']) {
      final root = Directory(dir);
      if (!root.existsSync()) continue;
      for (final file in root
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))) {
        final path = file.path.replaceAll(r'\', '/');
        if (path.contains('/generated/')) continue;
        final ownFeature = featureOf.firstMatch(path)?.group(1);
        for (final line in file.readAsLinesSync()) {
          final match = importPattern.firstMatch(line);
          if (match == null) continue;
          final importedPath = match.group(1)!; // features/<f>/viewmodel/<file>
          final importedFeature = match.group(2)!;
          if (importedFeature == ownFeature) continue;
          if (_sharedProviders.containsKey(importedPath)) continue;
          violations.add('$path -> $importedPath');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'A file imports another feature\'s screen view model, breaking the '
          'one-view-one-view-model boundary. Fix it by (a) driving the shared '
          'state through the data layer (repository/service), or (b) if the '
          'provider genuinely holds app-wide shared state, moving it into '
          '`data/` — or, as a last resort, classifying it in _sharedProviders '
          'with a justification:\n${violations.join('\n')}',
    );
  });

  // The rule is "view models depend on repositories and services, never on a
  // sibling view model". The test above only catches the cross-feature half of
  // that, so same-feature sibling coupling used to slip through.
  test('no view model imports another view model', () {
    final importPattern = RegExp(
      r'''import\s+['"]package:resonate/(features/\w+/viewmodel/[^'"]+)['"]''',
    );
    final ownFile = RegExp(r'lib/features/\w+/viewmodel/');
    final violations = <String>[];

    for (final file in Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'\', '/');
      if (!ownFile.hasMatch(path) || path.contains('/generated/')) continue;
      for (final line in file.readAsLinesSync()) {
        final match = importPattern.firstMatch(line);
        if (match == null) continue;
        final importedPath = match.group(1)!;
        // A view model importing its own file is impossible; anything else here
        // is one screen's view model reaching into another's.
        if (_sharedProviders.containsKey(importedPath)) continue;
        if (path.endsWith(importedPath)) continue;
        violations.add('$path -> $importedPath');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'A view model imports another view model. If it only needs to refresh '
          'shared data, that data belongs in `data/` and both should read it '
          'from there:\n${violations.join('\n')}',
    );
  });

  // Views must have a one-to-one relationship with its ViewModel
  test('a view imports at most one screen view model', () {
    final importPattern = RegExp(
      r'''import\s+['"]package:resonate/(features/\w+/viewmodel/[^'"]+)['"]''',
    );
    final violations = <String>[];

    for (final file in Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'\', '/');
      if (!path.contains('/view/') || path.contains('/generated/')) continue;
      final viewModels = <String>{};
      for (final line in file.readAsLinesSync()) {
        final match = importPattern.firstMatch(line);
        if (match == null) continue;
        final importedPath = match.group(1)!;
        if (_sharedProviders.containsKey(importedPath)) continue;
        viewModels.add(importedPath);
      }
      if (viewModels.length > 1) {
        violations.add('$path -> {${viewModels.join(', ')}}');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'A view imports more than one screen view model. Give the screen a '
          'single view model that owns its UI state (fold the extra ones in), '
          'or read shared *data* from the data layer instead:\n'
          '${violations.join('\n')}',
    );
  });
  // A service is the leaf of the data layer
  test('no data-layer service imports a repository', () {
    final importPattern = RegExp(
      r"""import\s+['"]package:resonate/(features/\w+/data/repositories/[^'"]+)['"]""",
    );
    final violations = <String>[];

    for (final file in Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'\', '/');
      if (!path.contains('/data/services/') || path.contains('/generated/')) {
        continue;
      }
      for (final line in file.readAsLinesSync()) {
        final match = importPattern.firstMatch(line);
        if (match == null) continue;
        violations.add('$path -> ${match.group(1)}');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'A file under `data/services/` imports a repository, inverting the '
          'repository -> service direction. Either the dependency belongs the '
          'other way round, or the file is a coordinator rather than a '
          'service and should move up to `data/`:\n${violations.join('\n')}',
    );
  });

  test('no view or view model imports a platform SDK', () {
    const sdks = <String>[
      'package:appwrite/',
      'package:livekit_client/',
      'package:firebase_',
      'package:flutter_callkit_incoming/',
      'package:get_storage/',
      'package:image_picker/',
      'package:file_picker/',
      'package:path_provider/',
      'package:audioplayers/',
      'package:record/',
      'package:flutter_local_notifications/',
      'package:connectivity_plus/',
    ];
    final importPattern = RegExp(r"""import\s+['"]([^'"]+)['"]""");
    final violations = <String>[];

    for (final file in Directory('lib/features')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      final path = file.path.replaceAll(r'\', '/');
      final isUi = path.contains('/view/') || path.contains('/viewmodel/');
      if (!isUi || path.contains('/generated/')) continue;
      for (final line in file.readAsLinesSync()) {
        final match = importPattern.firstMatch(line);
        if (match == null) continue;
        final uri = match.group(1)!;
        if (sdks.any(uri.startsWith)) violations.add('$path -> $uri');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'A view or view model imports a platform SDK directly. Wrap the I/O '
          'in a `data/services/` service and depend on that instead, so the '
          'UI stays testable without a platform channel:\n'
          '${violations.join('\n')}',
    );
  });
}
