import 'package:appwrite/appwrite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/core/errors/appwrite_error.dart';

void main() {
  group('classifyAppwriteError', () {
    test('404 is not found', () {
      expect(
        classifyAppwriteError(AppwriteException('gone', 404)),
        AppwriteErrorKind.notFound,
      );
    });

    test('401 and 403 are both permission denied', () {
      expect(
        classifyAppwriteError(AppwriteException('unauthorized', 401)),
        AppwriteErrorKind.permissionDenied,
      );
      expect(
        classifyAppwriteError(AppwriteException('forbidden', 403)),
        AppwriteErrorKind.permissionDenied,
      );
    });

    test('anything else is unknown', () {
      for (final code in [400, 409, 429, 500, null]) {
        expect(
          classifyAppwriteError(AppwriteException('boom', code)),
          AppwriteErrorKind.unknown,
          reason: 'code $code should not be classified',
        );
      }
    });
  });
}
