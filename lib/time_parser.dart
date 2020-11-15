import 'package:intl/intl.dart';

class TimeParser {
  static const FORMAT_HOUR_MINUTE = 'HH:mm';
  static const FORMAT_HOUR_MINUTE_SEC = 'HH:mm:ss';
  static const FORMAT_DAY_MONTH = 'dd.MM';

  static String date(int time) {
    final ts = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat(FORMAT_DAY_MONTH).format(ts);
  }

  static String hm(int time) {
    final ts = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat(FORMAT_HOUR_MINUTE).format(ts);
  }

  static String hms(int time) {
    final ts = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat(FORMAT_HOUR_MINUTE_SEC).format(ts);
  }

  static String msecHumanReadableFormat(int milliseconds) {
    return DateTime.fromMillisecondsSinceEpoch(milliseconds).toString();
  }
}
