import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:fastotv_common/colors.dart';

const BUTTON_OPACITY = 0.5;

enum ColorType { Primary, Accent }

class MyColorPicker extends StatefulWidget {
  final String dialogHeader;
  final String tileTitle;
  final String cancel;
  final String submit;
  final ColorType color;

  const MyColorPicker.primary({this.dialogHeader, this.tileTitle, this.submit, this.cancel})
      : color = ColorType.Primary;

  const MyColorPicker.accent({this.dialogHeader, this.tileTitle, this.submit, this.cancel}) : color = ColorType.Accent;

  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<MyColorPicker> {
  Color tempShadePrColor;

  Color tempShadeAcColor;

  void _openColorPicker(ThemeModel model) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              contentPadding: const EdgeInsets.all(6.0),
              title: Text(widget.dialogHeader ?? "Color picker"),
              content: _content(model),
              actions: [_cancel(model), _submit(model)]);
        });
  }

  Widget _content(ThemeModel model) {
    return MaterialColorPicker(
        shrinkWrap: true,
        iconSelected: Icons.check,
        selectedColor: widget.color == ColorType.Primary ? model.primaryColor : model.accentColor,
        onColorChange: (color) => widget.color == ColorType.Primary
            ? setState(() => tempShadePrColor = color)
            : setState(() => tempShadeAcColor = color));
  }

  Widget _cancel(ThemeModel model) {
    return Opacity(
        opacity: BUTTON_OPACITY,
        child: FlatButton(
            child: Text(widget.cancel ?? 'CANCEL'),
            textColor: CustomColor().themeBrightnessColor(context),
            onPressed: () => Navigator.of(context).pop()));
  }

  Widget _submit(ThemeModel model) {
    return FlatButton(
        child: Text(widget.submit ?? 'SUBMIT'),
        textColor: model.accentColor,
        onPressed: () {
          Navigator.of(context).pop();
          widget.color == ColorType.Primary
              ? _setPrimary(model, tempShadePrColor)
              : _setAccent(model, tempShadeAcColor);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color == ColorType.Primary) {
      return _primary();
    } else if (widget.color == ColorType.Accent) {
      return _accent();
    }
    return SizedBox();
  }

  Widget _primary() {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      final canChange = model.type != ThemeType.light && model.type != ThemeType.dark;
      return Opacity(
          opacity: !canChange ? 0.5 : 1.0,
          child: ListTile(
              leading: Icon(Icons.format_color_fill, color: CustomColor().themeBrightnessColor(context)),
              title: Text(widget.tileTitle ?? "Primary color"),
              subtitle: Text(Theme.of(context).accentColor.toString()),
              onTap: !canChange ? null : () => _openColorPicker(model),
              trailing: _colorCircle(Theme.of(context).primaryColor, model)));
    });
  }

  Widget _accent() {
    return Consumer<ThemeModel>(
        builder: (context, model, child) => ListTile(
            leading: Icon(Icons.colorize, color: CustomColor().themeBrightnessColor(context)),
            title: Text(widget.tileTitle ?? "Accent color"),
            subtitle: Text(Theme.of(context).accentColor.toString()),
            onTap: () => _openColorPicker(model),
            trailing: _colorCircle(model.accentColor, model)));
  }

  Widget _colorCircle(Color color, ThemeModel model) {
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: CustomColor().primaryColorBrightness(model))));
  }

  void _setPrimary(ThemeModel model, Color color) => model.changePrimaryColor(color);

  void _setAccent(ThemeModel model, Color color) => model.changeAccentColor(color);
}

class MyThemePicker extends StatefulWidget {
  final String tileTitle;
  final String dialogTitle;
  final String light;
  final String dark;
  final String lightColor;
  final String darkColor;

  const MyThemePicker({this.tileTitle, this.dialogTitle, this.light, this.dark, this.lightColor, this.darkColor});

  _MyThemePickerState createState() => _MyThemePickerState();
}

class _MyThemePickerState extends State<MyThemePicker> {
  int themeGroupValue = 0;
  String light;
  String dark;
  String lightColor;
  String darkColor;

  @override
  void initState() {
    super.initState();
    light = widget.light ?? 'Light';
    dark = widget.dark ?? 'Dark';
    lightColor = widget.lightColor ?? 'Colored light';
    darkColor = widget.darkColor ?? 'Colored dark';
  }

  void _handleTheme(int value, ThemeModel model) {
    setState(() {
      themeGroupValue = value;
      switch (themeGroupValue) {
        case 0:
          model.changeDarkMode(false);
          model.changeCustomTheme(false);
          model.changeTrueBlack(false);
          break;

        case 1:
          model.changeDarkMode(true);
          model.changeCustomTheme(false);
          model.changeTrueBlack(false);
          break;

        case 2:
          model.changeDarkMode(false);
          model.changeCustomTheme(true);
          model.changeTrueBlack(false);
          break;

        case 3:
          model.changeDarkMode(true);
          model.changeCustomTheme(false);
          model.changeTrueBlack(true);
          break;
        default:
      }
    });
    Navigator.of(context).pop();
  }

  Widget _dialogItem(String text, int itemvalue, ThemeModel model) {
    return RadioListTile(
        activeColor: Theme.of(context).accentColor,
        title: Text(text),
        value: itemvalue,
        groupValue: themeGroupValue,
        onChanged: (int value) {
          _handleTheme(value, model);
        });
  }

  void _showAlertDialog(BuildContext context, ThemeModel model) {
    final dialog = SimpleDialog(
        contentPadding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
        title: Text(widget.dialogTitle ?? 'Choose theme'),
        children: <Widget>[
          _dialogItem(light, 0, model),
          _dialogItem(dark, 1, model),
          _dialogItem(lightColor, 2, model),
          _dialogItem(darkColor, 3, model)
        ]);

    // show the dialog
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  String themeName(ThemeModel model) {
    if (model.type == ThemeType.dark) {
      return dark;
    } else if (model.type == ThemeType.custom) {
      return lightColor;
    } else if (model.type == ThemeType.black) {
      return darkColor;
    }
    return light;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      int currentTheme() {
        return model.type == ThemeType.light
            ? 0
            : model.type == ThemeType.dark
                ? 1
                : model.type == ThemeType.custom ? 2 : model.type == ThemeType.black ? 3 : 0;
      }

      themeGroupValue = currentTheme();
      return ListTile(
          leading: Icon(Icons.color_lens, color: CustomColor().themeBrightnessColor(context)),
          title: Text(widget.tileTitle ?? "General theme"),
          subtitle: Text(themeName(model)),
          onTap: () => _showAlertDialog(context, model));
    });
  }
}

class ListHeader extends StatelessWidget {
  const ListHeader({@required this.text});

  final String text;

  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
          SizedBox(height: 32),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(text, style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor)))
        ]));
  }
}
