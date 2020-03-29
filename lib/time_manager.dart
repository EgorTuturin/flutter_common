import 'dart:async';

import 'package:ntp/ntp.dart';

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


