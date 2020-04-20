import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final String title;
  final bool _init;
  final void Function(bool) onChangedState;

  CheckBox({@required this.title, bool init, this.onChangedState}) : _init = init;

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget._init != null ? widget._init : false;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(widget.title),
        value: _value,
        onChanged: (value) {
          setState(() {
            _value = value;
            if (widget.onChangedState != null) {
              widget.onChangedState(value);
            }
          });
        });
  }
}
