import 'package:fastotv_common/colors.dart';
import 'package:flutter/material.dart';

typedef RecordedCallback = void Function(bool recorded);

class RecordButton extends StatefulWidget {
  final Color selectedColor;
  final Color unselectedColor;
  final Color textColor;
  final bool initRecorded;
  final RecordedCallback onRecordedChanged;
  final int type;
  final String queuedText;
  final String recordText;

  RecordButton.icon(this.initRecorded,
      {this.onRecordedChanged, this.selectedColor, this.unselectedColor, this.textColor})
      : type = 0,
        queuedText = '',
        recordText = '';

  RecordButton.button(this.initRecorded,
      {this.onRecordedChanged,
      this.selectedColor,
      this.unselectedColor,
      this.textColor,
      this.queuedText,
      this.recordText})
      : type = 1;

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
    final textColor = widget.textColor ?? CustomColor().themeBrightnessColor(context);

    Widget _iconButton() {
      return IconButton(
          icon: Icon(_recorded ? Icons.access_time : Icons.save),
          color: _recorded ? accentColor : textColor.withOpacity(0.3),
          onPressed: () => setRecorded(!_recorded));
    }

    Widget _outlineButton() {
      return OutlineButton(
          borderSide: BorderSide(color: accentColor),
          color: Colors.redAccent,
          child: Text(widget.recordText ?? "Record", style: TextStyle(color: textColor)),
          onPressed: () {
            setRecorded(true);
          });
    }

    Widget _flatButton() {
      final textStyle = TextStyle(color: CustomColor().backGroundColorBrightness(accentColor));
      return FlatButton(
          color: accentColor,
          child: Text(widget.queuedText ?? "Queued", style: textStyle),
          onPressed: () {
            setRecorded(false);
          });
    }

    if (widget.type == 1) {
      if (_recorded) {
        return _flatButton();
      }
      return _outlineButton();
    }
    return _iconButton();
  }
}
