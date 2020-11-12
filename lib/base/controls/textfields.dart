import 'package:flutter_common/base/controls/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class TextFieldEx extends StatefulWidget {
  final Function(String term) onFieldChanged;
  final Function(String term) onFieldSubmit;
  final String init;
  final String hintText;
  final String Function(String term) validator;
  final TextInputType keyboardType;
  final String errorText;
  final bool autofocus;
  final List<TextInputFormatter> formatters;
  final int minSymbols;
  final int maxSymbols;
  final TextEditingController controller;
  final bool clearable;
  final EdgeInsets padding;
  final InputDecoration decoration;

  TextFieldEx(
      {this.onFieldChanged,
      this.onFieldSubmit,
      this.init,
      bool clearable,
      this.hintText,
      this.validator,
      this.keyboardType,
      String errorText,
      this.controller,
      this.formatters,
      this.minSymbols,
      this.maxSymbols,
      EdgeInsets padding,
      this.decoration,
      this.autofocus = false})
      : this.errorText = errorText ?? '',
        this.clearable = clearable ?? false,
        this.padding = padding ?? const EdgeInsets.all(8.0);

  TextFieldEx copyWith(
      {Function(String term) onFieldChanged,
      Function(String term) onFieldSubmit,
      String init,
      String hintText,
      String Function(String term) validator,
      TextInputType keyboardType,
      String errorText,
      bool autofocus,
      List<TextInputFormatter> formatters,
      int minSymbols,
      int maxSymbols,
      EdgeInsets padding,
      TextEditingController controller,
      InputDecoration decoration,
      bool clearable}) {
    return TextFieldEx(
        onFieldChanged: onFieldChanged ?? this.onFieldChanged,
        onFieldSubmit: onFieldSubmit ?? this.onFieldSubmit,
        init: init ?? this.init,
        clearable: clearable ?? this.clearable,
        hintText: hintText ?? this.hintText,
        validator: validator ?? this.validator,
        keyboardType: keyboardType ?? this.keyboardType,
        errorText: errorText ?? this.errorText,
        controller: controller ?? this.controller,
        formatters: formatters ?? this.formatters,
        minSymbols: minSymbols ?? this.minSymbols,
        maxSymbols: maxSymbols ?? this.maxSymbols,
        padding: padding ?? this.padding,
        decoration: decoration ?? this.decoration,
        autofocus: autofocus ?? this.autofocus);
  }

  @override
  _TextFieldExState createState() => _TextFieldExState();
}

class _TextFieldExState extends State<TextFieldEx> {
  bool _validator = true;
  bool _hidePassword = false;

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.init ?? '');
  }

  @override
  void didUpdateWidget(TextFieldEx oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: TextFormField(
            validator: _validate,
            inputFormatters: _formatters(),
            controller: _controller,
            autofocus: widget.autofocus,
            obscureText: _hidePassword,
            keyboardType: widget.keyboardType,
            onFieldSubmitted: widget.onFieldSubmit?.call,
            onChanged: _onField,
            decoration: _decoration()));
  }

  List<TextInputFormatter> _formatters() {
    List<TextInputFormatter> _list = widget.formatters ?? [];
    if (widget.maxSymbols != null) {
      _list.add(LengthLimitingTextInputFormatter(widget.maxSymbols));
    }
    return _list;
  }

  InputDecoration _decoration() {
    if (widget.clearable) {
      return (widget.decoration ?? TextFieldExDecoration(hintText: widget.hintText)).copyWith(suffixIcon: clearButton());
    }
    return (widget.decoration ?? TextFieldExDecoration(hintText: widget.hintText));
  }

  Widget clearButton() {
    return IconButton(tooltip: 'Clear', icon: Icon(Icons.clear), onPressed: _clear);
  }

  void _clear() {
    _controller.clear();
    setState(() {});
  }

  void _onField(String term) {
    if (term.isNotEmpty != _validator) {
      setState(() => _validator = term.isNotEmpty);
    }

    widget.onFieldChanged?.call(term);
  }

  String _validate(String term) {
    if (widget.validator != null) {
      final _message = widget.validator(term);
      if (_message != null) {
        return _message;
      }
    }

    if (term.isEmpty) {
      if (widget.errorText.isNotEmpty) {
        return widget.errorText;
      }
    } else {
      if (widget.maxSymbols != null) {
        if (widget.maxSymbols < term.length) {
          return 'Maximum ${widget.hintText} length is ${widget.maxSymbols}';
        }
      }

      if (widget.minSymbols != null) {
        if (widget.minSymbols > term.length) {
          return 'Minimum ${widget.hintText} length is ${widget.minSymbols}';
        }
      }
    }

    return null;
  }
}

class PassWordTextField extends TextFieldEx {
  PassWordTextField({Function(String term) onFieldChanged, String hintText, String init, String errorText = '', EdgeInsets padding, InputDecoration decoration})
      : super(
            keyboardType: TextInputType.visiblePassword,
            onFieldChanged: onFieldChanged,
            init: init,
            hintText: hintText,
            errorText: errorText,
            padding: padding, 
            decoration: decoration);

  @override
  _PassWordTextFieldState createState() => _PassWordTextFieldState();
}

class _PassWordTextFieldState extends _TextFieldExState {
  @override
  bool _hidePassword = true;

  Widget _setObscureButton() {
    return IconButton(
        icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off, color: Colors.black),
        onPressed: () => setState(() => _hidePassword = !_hidePassword));
  }

  Widget _suffixButton() {
    if (widget.clearable) {
      return Row(mainAxisSize: MainAxisSize.min, children: [_setObscureButton(), clearButton()]);
    } else {
      return _setObscureButton();
    }
  }

  @override
  InputDecoration _decoration() {
    return (widget.decoration ?? TextFieldExDecoration(hintText: widget.hintText)).copyWith(suffixIcon: _suffixButton());
  }
}

class NumberTextField extends StatelessWidget {
  final Function(double term) onFieldChangedDouble;
  final double initDouble;
  final double minDouble;
  final double maxDouble;

  final Function(int term) onFieldChangedInt;
  final int initInt;
  final int minInt;
  final int maxInt;

  final String hintText;
  final bool canBeEmpty;
  final String Function(String term) validator;
  final TextEditingController textEditingController;
  final bool autofocus;
  final List<TextInputFormatter> formatters;
  final InputDecoration decoration;

  final bool decimal;

  NumberTextField.integer(
      {this.onFieldChangedInt,
      this.initInt,
      int minInt,
      int maxInt,
      this.hintText,
      this.validator,
      this.textEditingController,
      this.formatters,
      this.canBeEmpty = true,
      this.autofocus = false,
      this.decoration})
      : decimal = false,
        this.minInt = minInt ?? 0,
        this.maxInt = maxInt,
        this.initDouble = null,
        this.minDouble = null,
        this.maxDouble = null,
        onFieldChangedDouble = null;

  NumberTextField.decimal(
      {this.onFieldChangedDouble,
      this.initDouble,
      double minDouble,
      double maxDouble,
      this.hintText,
      this.validator,
      this.textEditingController,
      this.formatters,
      this.canBeEmpty = true,
      this.autofocus = false,
      this.decoration})
      : decimal = true,
        this.minDouble = minDouble ?? 0.0,
        this.maxDouble = maxDouble,
        this.initInt = null,
        this.minInt = null,
        this.maxInt = null,
        onFieldChangedInt = null;

  @override
  Widget build(BuildContext context) {
    return TextFieldEx(
        decoration: decoration,
        formatters: <TextInputFormatter>[decimal ? TextFieldFilter.digitsDecimal : TextFieldFilter.digits],
        validator: (term) => _validate(term),
        hintText: hintText,
        keyboardType: TextInputType.numberWithOptions(signed: _signed()),
        errorText: canBeEmpty ? null : 'Input $hintText',
        init: _init(),
        onFieldChanged: (term) =>
            decimal ? onFieldChangedDouble(double.tryParse(term)) : onFieldChangedInt(int.tryParse(term)));
  }

  String _init() {
    if (decimal) {
      return initDouble == null ? '' : initDouble.toString();
    } else {
      return initInt == null ? '' : initInt.toString();
    }
  }

  bool _signed() {
    if (decimal) {
      if (minDouble < 0.0) {
        return true;
      }
    } else {
      if (minInt < 0) {
        return true;
      }
    }
    return false;
  }

  String _validate(String term) {
    if (decimal) {
      final _value = double.tryParse(term) ?? 0;
      if (maxDouble != null) {
        if (_value > maxDouble) {
          return 'Maximum value is ' + maxDouble.toStringAsFixed(1);
        }
      }
      if (_value < minDouble && term.isNotEmpty) {
        return 'Minimum value is ' + minDouble.toStringAsFixed(1);
      }
    } else {
      final _value = int.tryParse(term) ?? 0;
      if (maxInt != null) {
        if (_value > maxInt) {
          return 'Maximum value is $maxInt';
        }
      }
      if (_value < minInt && term.isNotEmpty) {
        return 'Minimum value is $minInt';
      }
    }

    return null;
  }
}

class TextFieldExDecoration extends InputDecoration {
  final String errorText;
  final String hintText;

  TextFieldExDecoration({this.errorText, this.hintText})
      : super(
            errorText: errorText,
            labelText: hintText,
            errorBorder: outlineBorder(Colors.redAccent),
            border: outlineBorder(Colors.black54),
            focusedBorder: outlineBorder(ACTIVE_COLOR));

  static OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(borderSide: BorderSide(color: color, width: 1));
  }
}

class TextFieldFilter {
  static TextInputFormatter get url => FilteringTextInputFormatter.allow(RegExp("[!#-;=?-Za-z_~]"));

  static TextInputFormatter get digits => FilteringTextInputFormatter.allow(RegExp(r'\d+'));

  static TextInputFormatter get digitsDecimal => FilteringTextInputFormatter.allow(RegExp("[0-9.]"));

  static TextInputFormatter get license => FilteringTextInputFormatter.allow(RegExp("[a-f0-9]"));

  static TextInputFormatter get root => FilteringTextInputFormatter.allow(RegExp("[A-Za-z/~._0-9]"));
}
