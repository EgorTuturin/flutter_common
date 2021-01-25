import 'package:flutter/material.dart';

class DropdownButtonEx<T> extends DropdownButtonExTypes<T, T> {
  const DropdownButtonEx(
      {@required T value,
      @required List<T> values,
      @required void Function(T value) onChanged,
      @required DropdownMenuItem<T> Function(T value) itemBuilder,
      String hint,
      EdgeInsets padding = const EdgeInsets.all(16.0)})
      : super(
            value: value,
            values: values,
            onChanged: onChanged,
            itemBuilder: itemBuilder,
            hint: hint,
            padding: padding);
}

class DropdownButtonExTypes<T, S> extends StatelessWidget {
  final String hint;
  final T value;
  final List<S> values;
  final void Function(T value) onChanged;
  final DropdownMenuItem<T> Function(S value) itemBuilder;
  final EdgeInsets padding;

  const DropdownButtonExTypes(
      {@required this.value,
      @required this.values,
      @required this.onChanged,
      @required this.itemBuilder,
      this.hint,
      this.padding = const EdgeInsets.all(16.0)});

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<T>> content = [];
    for (final S value in values) {
      content.add(itemBuilder(value));
    }
    return Padding(
        padding: padding,
        child: DropdownButton<T>(
            isDense: true,
            isExpanded: true,
            hint: hint != null ? Text(hint) : null,
            value: value,
            onChanged: onChanged,
            items: content));
  }
}
