import 'package:flutter/material.dart';

import 'package:fastotv_common/colors.dart';

typedef RecordedCallback = void Function(bool recorded);

class RecordButton extends StatefulWidget {
  final Color selectedColor;
  final Color unselectedColor;
  final Color textColor;
  final bool initRecorded;
  final RecordedCallback onRecordedChanged;

  RecordButton(this.initRecorded, {this.onRecordedChanged, this.selectedColor, this.unselectedColor, this.textColor});

  @override
  _RecordButtonState createState() {
    return _RecordButtonState();
  }
}

class _RecordButtonState extends State<RecordButton> {
  bool _recorded = false;

  @override
  void initState() {
    super.initState();
    _recorded = widget.initRecorded;
  }

  void setRecorded(bool recorded) {
    setState(() {
      _recorded = recorded;
      if (widget.onRecordedChanged != null) {
        widget.onRecordedChanged(recorded);
      }
    });
  }

   @override
  void didUpdateWidget(RecordButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _recorded = widget.initRecorded;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.selectedColor ?? Theme.of(context).accentColor;
    if (_recorded) {
      final textStyle = TextStyle(
          color: CustomColor().backGroundColorBrightness(accentColor));
      return FlatButton(
          color: accentColor,
          child: Text("Queued", style: textStyle),
          onPressed: () {
            setRecorded(false);
          });
    }

    return OutlineButton(
        borderSide: BorderSide(color: accentColor),
        child: Text("Record", style: TextStyle(color: widget.textColor ?? CustomColor().themeBrightnessColor(context))),
        onPressed: () {
          setRecorded(true);
        });
  }
}
