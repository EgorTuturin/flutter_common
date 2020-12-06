import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_common/colors.dart';

class FlatButtonEx extends StatelessWidget {
  final bool filled;
  final String text;
  final void Function() onPressed;

  FlatButtonEx.filled({@required this.text, this.onPressed}) : filled = true;

  FlatButtonEx.notFilled({@required this.text, this.onPressed}) : filled = false;

  @override
  Widget build(BuildContext context) {
    Color activeColor = Theme.of(context).accentColor;
    Color disabledColor = Theme.of(context).disabledColor;
    return FlatButton(
        onPressed: onPressed == null ? null : () => onPressed(),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        textColor: filled ? backgroundColorBrightness(activeColor) : activeColor,
        disabledColor: disabledColor,
        disabledTextColor: backgroundColorBrightness(disabledColor),
        color: filled ? activeColor : null);
  }
}
