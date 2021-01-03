import 'package:flutter/material.dart';

class LocalePicker extends StatefulWidget {
  final String current;
  final List values;
  final String title;
  final void Function(String value) onChanged;

  const LocalePicker({this.current, this.values, this.title, this.onChanged});

  @override
  _LocalePickerState createState() {
    return _LocalePickerState();
  }
}

class _LocalePickerState extends State<LocalePicker> {
  String _current = '';
  final Map<String, String> _locales = {};

  @override
  void initState() {
    super.initState();
    _parseLocales();
  }

  @override
  void didUpdateWidget(LocalePicker old) {
    super.didUpdateWidget(old);
    if (old.values != widget.values) {
      _parseLocales();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.values.isNotEmpty) {
      final List<DropdownMenuItem<String>> items = [];
      _locales.forEach((key, value) {
        final item = DropdownMenuItem(child: Text(value), value: key);
        items.add(item);
      });

      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButton<String>(
              isDense: true,
              isExpanded: true,
              hint: Text(widget.title),
              value: _current,
              onChanged: (c) => _onChanged(c),
              items: items));
    }
    return const SizedBox();
  }

  void _parseLocales() {
    _current = widget.current;
    widget.values.forEach((country) => _locales[country[0]] = country[1]);
  }

  void _onChanged(String value) {
    setState(() => _current = value);
    widget.onChanged(value);
  }
}
