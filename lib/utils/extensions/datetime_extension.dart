import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import '../../../l10n/app_localizations.dart';

extension DateTimeExtensions on DateTime {
  /// Formats a DateTime to a localized format with date and time
  ///
  /// Uses the provided [locale] to format the date and time appropriately.
  /// Special handling for Haitian Creole (ht) language code.
  String dateToLocalFormatted(Locale locale) {
    final localDateTime = toLocal();

    final localDate = DateFormat.yMd().format(localDateTime);

    String localTime = DateFormat.jm().format(localDateTime);

    if (locale.languageCode == 'ht') {
      final timePeriod = localDateTime.hour < 12 ? 'AM' : 'PM';
      localTime =
          DateFormat.jm(locale.languageCode).format(localDateTime) + timePeriod;
    }

    return '$localDate $localTime';
  }

  /// Formats a DateTime to show relative time (e.g., "5 minutes ago")
  ///
  /// Uses the app's localization system to provide translated strings.
  /// Requires a [context] to access localized strings.
  /// Falls back to date format (YYYY-MM-DD) for dates older than 7 days.
  String formatDateTime(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(this);
    final localizations = AppLocalizations.of(context)!;

    if (difference.inMinutes < 60) {
      return localizations.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return localizations.hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return localizations.daysAgo(difference.inDays);
    } else {
      return '$year-$month-$day';
    }
  }
}
