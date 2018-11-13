import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

enum DateFormatPattern { general, timeAgo }

class DateFormatter {
  static String dateToString(DateTime date,
      [DateFormatPattern pattern = DateFormatPattern.general]) {
    String formatPattern = '';
    String formatted = '';
    switch (pattern) {
      case DateFormatPattern.general:
        formatPattern = 'yyyy-MM-dd HH:mm:ss';
        var formatter = new DateFormat(formatPattern);
        formatted = formatter.format(date);
        break;
      case DateFormatPattern.timeAgo:
        formatted =  timeago.format(date);
        break;
    }

    return formatted;
  }
}
