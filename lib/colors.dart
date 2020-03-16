import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';

class CustomColor {
  CustomColor();

  Color themeBrightnessColor(BuildContext context, {Color dark, Color light}) {
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  Color primaryColorBrightness(ThemeModel model, {Color dark, Color light}) {
    if (ThemeData.estimateBrightnessForColor(model.primaryColor) == Brightness.light || model.type == ThemeType.light) {
      return light ?? Colors.black;
    }
    return dark ?? Colors.white;
  }

  Color accentColorBrightness(ThemeModel model, {Color dark, Color light}) {
    if (ThemeData.estimateBrightnessForColor(model.accentColor) == Brightness.light || model.type == ThemeType.light) {
      return light ?? Colors.black;
    }
    return dark ?? Colors.white;
  }

  Color backGroundColorBrightness(Color color, {Color dark, Color light}) {
    if (ThemeData.estimateBrightnessForColor(color) == Brightness.light) {
      return light ?? Colors.black;
    }
    return dark ?? Colors.white;
  }

  Color tvSelectedColor() {
    return Colors.amber;
  }

  Color tvUnselectedColor() {
    return Colors.grey;
  }
}
