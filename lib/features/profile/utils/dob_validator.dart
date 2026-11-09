import 'package:intl/intl.dart';

const int minimumAge = 13;

DateTime? parseDob(String value) {
  try {
    final date = DateFormat('dd-MM-yyyy').parseStrict(value);
    // Reject impossible calendar dates (e.g. 31-02-2000) that would roll over.
    final formatted = DateFormat('dd-MM-yyyy').format(date);
    return formatted == value ? date : null;
  } on FormatException {
    return null;
  }
}

bool isAtLeastMinimumAge(DateTime dob, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final latestAllowed = DateTime(
    today.year - minimumAge,
    today.month,
    today.day,
  );
  return !dob.isAfter(latestAllowed);
}

bool isValidDob(String value, {DateTime? now}) {
  final dob = parseDob(value);
  if (dob == null) return false;
  final today = now ?? DateTime.now();
  if (dob.isAfter(today)) return false;
  return isAtLeastMinimumAge(dob, now: today);
}
