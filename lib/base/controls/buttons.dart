import 'package:flutter_common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
        textColor: filled ? CustomColor().backGroundColorBrightness(activeColor) : activeColor,
        disabledColor: disabledColor,
        disabledTextColor: CustomColor().backGroundColorBrightness(disabledColor),
        color: filled ? activeColor : null);
  }
}
