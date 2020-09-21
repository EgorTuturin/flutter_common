import 'package:flutter/material.dart';

class StateCheckBox extends StatefulWidget {
  final String title;
  final bool _init;
  final void Function(bool) onChanged;

  StateCheckBox({@required this.title, bool init, this.onChanged}) : _init = init;

  @override
  _CheckBoxState createState() {
    return _CheckBoxState();
  }
}

class _CheckBoxState extends State<StateCheckBox> {
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
            if (widget.onChanged != null) {
              widget.onChanged(value);
            }
          });
        });
  }
}
