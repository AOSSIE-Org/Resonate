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
}
