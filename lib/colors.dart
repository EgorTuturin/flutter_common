import 'package:flutter/material.dart';

Color themeBrightnessColor(BuildContext context, {Color dark, Color light}) {
  if (Theme.of(context).brightness == Brightness.light) {
    return light ?? Colors.black;
  }
  return dark ?? Colors.white;
}

Color backgroundColorBrightness(Color color, {Color onDark, Color onLight}) {
  if (ThemeData.estimateBrightnessForColor(color) == Brightness.light) {
    return onLight ?? Colors.black;
  }
  return onDark ?? Colors.white;
}
