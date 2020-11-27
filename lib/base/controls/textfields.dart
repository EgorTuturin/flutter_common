import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class TextFieldEx extends StatefulWidget {
  final void Function(String term) onFieldChanged;
  final void Function(String term) onFieldSubmit;
  final String init;
  final String hintText;
  final String Function(String term) validator;
  final TextInputType keyboardType;
  final String errorText;
  final bool autofocus;
  final bool readOnly;
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
      this.errorText,
      this.controller,
      this.formatters,
      this.minSymbols,
      this.maxSymbols,
      bool readOnly,
      EdgeInsets padding,
      this.decoration,
      bool autofocus})
      : this.clearable = clearable ?? false,
        this.autofocus = autofocus ?? false,
        this.readOnly = readOnly ?? false,
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
  _TextFieldExState createState() {
    return _TextFieldExState();
  }
}

class _TextFieldExState extends State<TextFieldEx> {
  bool _validator = true;
  bool _hidePassword = false;

  TextEditingController _controller;

  InputDecoration _decoration;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.init ?? '');
    _decoration = widget.decoration ?? InputDecoration();
    _decoration = _decoration.copyWith(
      hintText: widget.hintText,
      labelText: widget.hintText,
      suffixIcon: widget.clearable ? makeSuffix(_clearButton()) : null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.padding,
        child: TextFormField(
            validator: _validate,
            inputFormatters: _formatters(),
            controller: _controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            obscureText: _hidePassword,
            keyboardType: widget.keyboardType,
            onFieldSubmitted: widget.onFieldSubmit?.call,
            onChanged: _onField,
            decoration: decoration()));
  }

  List<TextInputFormatter> _formatters() {
    List<TextInputFormatter> _list = widget.formatters ?? [];
    if (widget.maxSymbols != null) {
      _list.add(LengthLimitingTextInputFormatter(widget.maxSymbols));
    }
    return _list;
  }

  InputDecoration decoration() {
    return _decoration;
  }

  Widget makeSuffix(Widget newSuffix) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [newSuffix] + (_decoration.suffixIcon != null ? [_decoration.suffixIcon] : []));
  }

  Widget _clearButton() {
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
      if (widget.errorText?.isNotEmpty ?? false) {
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
  PassWordTextField(
      {Function(String term) onFieldChanged,
      Function(String term) onFieldSubmit,
      String init,
      String hintText,
      String Function(String term) validator,
      String errorText,
      bool autofocus,
      List<TextInputFormatter> formatters,
      int minSymbols,
      int maxSymbols,
      EdgeInsets padding,
      TextEditingController controller,
      InputDecoration decoration,
      bool clearable})
      : super(
            onFieldChanged: onFieldChanged,
            onFieldSubmit: onFieldSubmit,
            init: init,
            clearable: clearable,
            hintText: hintText,
            validator: validator,
            keyboardType: TextInputType.visiblePassword,
            errorText: errorText,
            controller: controller,
            formatters: formatters,
            minSymbols: minSymbols,
            maxSymbols: maxSymbols,
            padding: padding,
            decoration: decoration,
            autofocus: autofocus);

  @override
  _PassWordTextFieldState createState() {
    return _PassWordTextFieldState();
  }
}

class _PassWordTextFieldState extends _TextFieldExState {
  @override
  bool _hidePassword = true;

  Widget _setObscureButton() {
    return IconButton(
        icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _hidePassword = !_hidePassword));
  }

  @override
  InputDecoration decoration() {
    return _decoration.copyWith(suffixIcon: makeSuffix(_setObscureButton()));
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

class TextFieldFilter {
  static TextInputFormatter get url => FilteringTextInputFormatter.allow(RegExp("[!#-;=?-Za-z_~]"));

  static TextInputFormatter get digits => FilteringTextInputFormatter.allow(RegExp(r'\d+'));

  static TextInputFormatter get digitsDecimal => FilteringTextInputFormatter.allow(RegExp("[0-9.]"));

  static TextInputFormatter get license => FilteringTextInputFormatter.allow(RegExp("[a-f0-9]"));

  static TextInputFormatter get root => FilteringTextInputFormatter.allow(RegExp("[A-Za-z/~._0-9]"));
}
