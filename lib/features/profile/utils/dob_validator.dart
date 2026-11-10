import 'package:intl/intl.dart';

/// Minimum age required by `PRIVACY-POLICY.md`.
const int minimumAge = 13;

/// Parses a strict `dd-MM-yyyy` date, returning null when it is malformed or
/// not a real calendar date (for example, `31-02-2000`).
DateTime? parseDob(String value) {
  try {
    final date = DateFormat('dd-MM-yyyy').parseStrict(value);
    // Round-tripping rejects dates that the parser would otherwise roll over.
    final formatted = DateFormat('dd-MM-yyyy').format(date);
    return formatted == value ? date : null;
  } on FormatException {
    return null;
  }
}

/// Whether [dob] is on or before the latest allowed birth date.
bool isAtLeastMinimumAge(DateTime dob, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final latestAllowed = DateTime(
    today.year - minimumAge,
    today.month,
    today.day,
  );
  return !dob.isAfter(latestAllowed);
}

/// Validates the format, past-date, and minimum-age rules.
bool isValidDob(String value, {DateTime? now}) {
  final dob = parseDob(value);
  if (dob == null) return false;
  final today = now ?? DateTime.now();
  if (dob.isAfter(today)) return false;
  return isAtLeastMinimumAge(dob, now: today);
}
