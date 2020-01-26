import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'package:fastotv_common/colors.dart';

const BUTTON_OPACITY = 0.5;

class MyColorPicker extends StatefulWidget {
  const MyColorPicker.primary() : color = 0;

  const MyColorPicker.accent() : color = 1;

  const MyColorPicker.reset() : color = 2;

  final int color;

  _PrimaryColorPickerState createState() => _PrimaryColorPickerState();
}

class _PrimaryColorPickerState extends State<MyColorPicker> {
  Color shadePrColor;
  Color tempShadePrColor;

  Color shadeAcColor;
  Color tempShadeAcColor;

  void _openDialog(
      BuildContext context, String title, Widget content, void changeColor()) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              contentPadding: const EdgeInsets.all(6.0),
              title: Text(title),
              content: content,
              actions: [
                Opacity(
                    opacity: BUTTON_OPACITY,
                    child: FlatButton(
                        child: Text('CANCEL'),
                        textColor: CustomColor().themeBrightnessColor(context),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })),
                FlatButton(
                    child: Text('SUBMIT'),
                    textColor: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                      changeColor();
                    })
              ]);
        });
  }

  void _openColorPicker(BuildContext context, void changeColor(), Color primary,
      Color accent) async {
    _openDialog(
        context,
        "Color picker",
        MaterialColorPicker(
            shrinkWrap: true,
            iconSelected: Icons.check,
            selectedColor: widget.color == 0 ? primary : accent,
            onColorChange: (color) => widget.color == 0
                ? setState(() {
                    tempShadePrColor = color;
                    shadePrColor = color;
                  })
                : setState(() {
                    tempShadeAcColor = color;
                    shadeAcColor = color;
                  })),
        changeColor);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color == 0) {
      return _primary();
    } else if (widget.color == 1) {
      return _accent();
    }
    return SizedBox();
  }

  Widget _primary() {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      return ListTile(
          leading: Icon(Icons.format_color_fill,
              color: CustomColor().themeBrightnessColor(context)),
          title: Text("Primary color"),
          subtitle: Text(Theme.of(context).accentColor.toString()),
          onTap: () {
            _openColorPicker(
                context,
                () => model.changePrimaryColor(tempShadePrColor),
                model.primaryColor,
                model.accentColor);
          },
          trailing: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: model.primaryColor,
                  border: Border.all(
                      color: CustomColor().primaryColorBrightness(model)))));
    });
  }

  Widget _accent() {
    return Consumer<ThemeModel>(
        builder: (context, model, child) => ListTile(
            leading: Icon(Icons.colorize,
                color: CustomColor().themeBrightnessColor(context)),
            title: Text("Accent color"),
            subtitle: Text(Theme.of(context).accentColor.toString()),
            onTap: () {
              _openColorPicker(
                  context,
                  () => model.changeAccentColor(tempShadeAcColor),
                  model.primaryColor,
                  model.accentColor);
            },
            trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: model.accentColor,
                    border: Border.all(
                        color: CustomColor().primaryColorBrightness(model))))));
  }
}

class MyThemePicker extends StatefulWidget {
  const MyThemePicker();

  _MyThemePickerState createState() => _MyThemePickerState();
}

class _MyThemePickerState extends State<MyThemePicker> {
  int themeGroupValue = 0;

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
        title: const Text('Choose theme'),
        children: <Widget>[
          _dialogItem("Light", 0, model),
          _dialogItem("Dark", 1, model),
          _dialogItem("Colored light", 2, model),
          _dialogItem("Colored dark", 3, model)
        ]);

    // show the dialog
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  String themeName(ThemeModel model) {
    if (model.type == ThemeType.dark) {
      return 'Dark';
    } else if (model.type == ThemeType.custom) {
      return 'Colored light';
    } else if (model.type == ThemeType.black) {
      return 'Colored dark';
    }
    return 'Light';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, model, child) {
      int currentTheme() {
        return model.type == ThemeType.light
            ? 0
            : model.type == ThemeType.dark
                ? 1
                : model.type == ThemeType.custom
                    ? 2
                    : model.type == ThemeType.black ? 3 : 0;
      }

      themeGroupValue = currentTheme();
      return ListTile(
          leading: Icon(Icons.color_lens,
              color: CustomColor().themeBrightnessColor(context)),
          title: Text("General theme"),
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
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
          SizedBox(height: 32),
          Align(
              alignment: Alignment.bottomRight,
              child: Text(text,
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).accentColor)))
        ]));
  }
}
