import 'dart:ui';

import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
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
String formatDateTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '$year-$month-$day';
    }
  }
}

