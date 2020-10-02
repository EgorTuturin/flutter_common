import 'package:flutter_common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Color ACTIVE_COLOR = Colors.blueAccent;

class FlatButtonEx extends StatelessWidget {
  static const DISABLED_COLOR = Colors.grey;

  final bool filled;
  final String text;
  final void Function() onPressed;

  FlatButtonEx.filled({@required this.text, this.onPressed}) : filled = true;

  FlatButtonEx.notFilled({@required this.text, this.onPressed}) : filled = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onPressed == null ? null : () => onPressed(),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        textColor: filled ? CustomColor().backGroundColorBrightness(ACTIVE_COLOR) : ACTIVE_COLOR,
        disabledColor: DISABLED_COLOR,
        disabledTextColor: CustomColor().backGroundColorBrightness(DISABLED_COLOR),
        color: filled ? ACTIVE_COLOR : null);
  }
}
