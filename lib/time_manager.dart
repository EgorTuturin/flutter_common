import 'dart:async';

import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';

import 'package:fastotv_dart/commands_info/programme_info.dart';

class TimeManager {
  static TimeManager _instance;
  DateTime _ntp;
  int _difference;

  static Future<TimeManager> getInstance() async {
    if (_instance == null) {
      _instance = TimeManager();
    }
    _instance._setNTP();
    return _instance;
  }

  void update() {
    _setNTP();
  }

  int differenceMSec() {
    if (_difference == null) {
      _setNTP();
    }
    return _difference;
  }

  int realTime() {
    if (_difference == null) {
      _setNTP();
    }
    final now = DateTime.now();
    return now.millisecondsSinceEpoch + _difference;
  }

  // private:
  void _setNTP() async {
    try {
      if (_ntp == null) {
        _ntp = await NTP.now();
        final now = DateTime.now();
        _difference = _ntp.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
      }
    } catch (e) {
      print('$e');
    }
  }
}

class TimeParser {
  static const FORMAT_HOUR_MINUTE = 'HH:mm';
  static const FORMAT_HOUR_MINUTE_SEC = 'HH:mm:ss';
  static const FORMAT_DAY_MONTH = 'dd.MM';

  static String formatProgram(ProgrammeInfo program) =>
      date(program.start) + ' / ' + hm(program.start) + ' - ' + hm(program.stop) + ' / ' + program.getDuration();

  static String date(int time) => DateFormat(FORMAT_DAY_MONTH).format(DateTime.fromMillisecondsSinceEpoch(time));

  static String hm(int time) => DateFormat(FORMAT_HOUR_MINUTE).format(DateTime.fromMillisecondsSinceEpoch(time));

  static String hms(int time) => DateFormat(FORMAT_HOUR_MINUTE_SEC).format(DateTime.fromMillisecondsSinceEpoch(time));
}
