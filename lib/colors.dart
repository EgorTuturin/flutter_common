import 'package:flutter/material.dart';

class CustomColor {
  CustomColor();

  Color themeBrightnessColor(BuildContext context, {Color dark, Color light}) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  Color backGroundColorBrightness(Color color, {Color dark, Color light}) {
    if (ThemeData.estimateBrightnessForColor(color) == Brightness.light) {
      return light ?? Colors.black;
    }
    return dark ?? Colors.white;
  }
}
