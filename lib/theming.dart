import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

const BUTTON_OPACITY = 0.5;

enum ColorType { Primary, Accent }

class ListHeader extends StatelessWidget {
  const ListHeader({@required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
          const SizedBox(height: 32),
          Align(
              alignment: Alignment.bottomRight,
              child:
                  Text(text, style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor)))
        ]));
  }
}

class ColorPickerDialog extends StatefulWidget {
  final String title;
  final Color initColor;
  final String submit;
  final String cancel;

  const ColorPickerDialog({this.title, @required this.initColor, this.submit, this.cancel});

  @override
  _ColorPickerDialogState createState() {
    return _ColorPickerDialogState();
  }
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  static const BUTTON_OPACITY = 0.5;

  Color tempShadeColor;

  @override
  void initState() {
    super.initState();
    tempShadeColor = widget.initColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(6.0),
        title: Text(widget.title ?? "Color picker"),
        content: _content(),
        actions: [_cancel(), _submit()]);
  }

  Widget _content() {
    return MaterialColorPicker(
        shrinkWrap: true,
        selectedColor: tempShadeColor,
        onColorChange: (color) => tempShadeColor = color);
  }

  Widget _cancel() {
    return Opacity(
        opacity: BUTTON_OPACITY,
        child: FlatButton(
            child: Text(widget.cancel ?? 'Cancel'), onPressed: () => Navigator.of(context).pop()));
  }

  Widget _submit() {
    return FlatButton(
        child: Text(widget.submit ?? 'Submit'),
        textColor: Theme.of(context).accentColor,
        onPressed: () => Navigator.of(context).pop(tempShadeColor));
  }
}
