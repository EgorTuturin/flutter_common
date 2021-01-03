import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_common/colors.dart';

class FlatButtonEx extends StatelessWidget {
  final bool filled;
  final String text;
  final void Function() onPressed;

  const FlatButtonEx.filled({@required this.text, this.onPressed}) : filled = true;

  const FlatButtonEx.notFilled({@required this.text, this.onPressed}) : filled = false;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Theme.of(context).accentColor;
    final Color disabledColor = Theme.of(context).disabledColor;
    return FlatButton(
        onPressed: onPressed?.call,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        textColor: filled ? backgroundColorBrightness(activeColor) : activeColor,
        disabledColor: disabledColor,
        disabledTextColor: backgroundColorBrightness(disabledColor),
        color: filled ? activeColor : null);
  }
}
