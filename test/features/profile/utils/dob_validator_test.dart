import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/profile/utils/dob_validator.dart';

void main() {
  final now = DateTime(2026, 11, 9);

  test('accepts a date exactly 13 years before now', () {
    expect(isValidDob('09-11-2013', now: now), isTrue);
  });

  test('rejects a date one day short of 13 years before now', () {
    expect(isValidDob('10-11-2013', now: now), isFalse);
  });

  test('rejects a future date', () {
    expect(isValidDob('10-11-2026', now: now), isFalse);
  });

  test('rejects malformed and impossible dates', () {
    expect(isValidDob('', now: now), isFalse);
    expect(isValidDob('2000-01-01', now: now), isFalse);
    expect(isValidDob('31-02-2000', now: now), isFalse);
  });

  test('accepts an older date', () {
    expect(isValidDob('01-01-2000', now: now), isTrue);
  });
}
