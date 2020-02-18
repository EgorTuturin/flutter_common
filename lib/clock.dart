import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Clock extends StatefulWidget {
  final int type;
  final double dateFontSize;
  final double timeFontSize;
  final double width;
  final Color textColor;

  Clock.date({this.dateFontSize, this.timeFontSize, this.width, this.textColor}) : type = 1;
  Clock.time({this.dateFontSize, this.timeFontSize, this.width, this.textColor}) : type = 2;
  Clock.full({this.dateFontSize, this.timeFontSize, this.width, this.textColor}) : type = 3;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _timeString;
  String _dateString;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _updateDate();
    _timer =
        Timer.periodic(Duration(minutes: 1), (Timer t) => _getCurrentTime());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8.0, right: 16),
        child: Container(
            width: widget.width ?? 100,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(_timeString, style: TextStyle(fontSize: widget.timeFontSize ?? 24, color: widget.textColor)),
                  Text(_dateString, style: TextStyle(fontSize: widget.dateFontSize ?? 18, color: widget.textColor))
                ])));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // private:
  void _getCurrentTime() {
    setState(() {
      _updateDate();
    });
  }

  void _updateDate() {
    final dateTime = DateTime.now();
    _timeString = DateFormat('Hm').format(dateTime);
    _dateString = DateFormat('E, MMM d').format(dateTime);
  }
}
