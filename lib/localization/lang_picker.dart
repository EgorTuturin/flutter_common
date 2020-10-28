import 'package:flutter/material.dart';
import 'package:flutter_common/localization/app_localizations.dart';
import 'package:flutter_common/tv/tv_controls.dart';

class LanguagePicker extends StatefulWidget {
  final Function(Locale) onChanged;
  final String chooseLangKey;
  final String languageKey;
  final String languageNameKey;
  final int type;

  const LanguagePicker.settings(this.onChanged, {this.languageKey, this.languageNameKey, this.chooseLangKey})
      : type = 0;

  const LanguagePicker.login(this.onChanged, {this.languageKey, this.languageNameKey, this.chooseLangKey}) : type = 1;

  @override
  _LanguagePickerState createState() {
    return _LanguagePickerState();
  }
}

class _LanguagePickerState extends State<LanguagePicker> with BaseTVControls {
  FocusScopeNode _dialogScope = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    if (widget.type == 0) {
      return _settings();
    } else if (widget.type == 1) {
      return _login();
    }
    return SizedBox();
  }

  void _showAlertDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return FocusScope(
              node: _dialogScope,
              child: SimpleDialog(
                  contentPadding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                  title: Text(_chooseLanguage),
                  children: <Widget>[
                    SingleChildScrollView(
                        child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: new List<Widget>.generate(supportedLocales.length, _dialogItem)))
                  ]));
        });
  }

  Widget _dialogItem(int index) {
    String text = supportedLanguages[index];
    Locale locale = supportedLocales[index];
    return ListTile(
        autofocus: index == 0,
        focusNode: FocusNode(onKey: (node, event) {
          return nodeAction(_dialogScope, node, event, () {
            _setLocale(locale);
          });
        }),
        leading: _radio(index),
        onTap: () {
          _setLocale(locale);
        },
        title: Text(text, overflow: TextOverflow.ellipsis));
  }

  Widget _radio(int index) {
    Color _color = Theme.of(context).accentColor;
    if (index == currentLanguageIndex()) {
      return Icon(Icons.radio_button_checked, color: _color);
    }
    return Icon(Icons.radio_button_unchecked);
  }

  Widget _settings() {
    return ListTile(
        leading: Icon(Icons.language), title: Text(_language), subtitle: Text(_languageName), onTap: _showAlertDialog);
  }

  Widget _login() {
    return FlatButton(
        focusNode: FocusNode(onKey: (node, event) {
          return nodeAction(FocusScope.of(context), node, event, _showAlertDialog);
        }),
        onPressed: _showAlertDialog,
        child: Opacity(
            opacity: 0.5,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Icon(Icons.language), SizedBox(width: 16), Text(_languageName)])));
  }

  void _setLocale(Locale locale) {
    AppLocalizations.of(context).load(locale);
    widget.onChanged?.call(locale);
    Navigator.of(context).pop();
  }

  List<Locale> get supportedLocales {
    return AppLocalizations.of(context).supportedLocales;
  }

  List<String> get supportedLanguages {
    return AppLocalizations.of(context).supportedLanguages;
  }

  int currentLanguageIndex() {
    final index = supportedLocales.indexOf(AppLocalizations.of(context).currentLocale);
    if (index < 0) {
      return 0;
    } else {
      return index;
    }
  }

  String get _language {
    if (widget.languageKey == null) {
      return "Language";
    }
    return AppLocalizations.of(context).translate(widget.languageKey);
  }

  String get _languageName {
    if (widget.languageNameKey == null) {
      return AppLocalizations.of(context).currentLanguage;
    }
    return AppLocalizations.of(context).translate(widget.languageNameKey);
  }

  String get _chooseLanguage {
    if (widget.chooseLangKey == null) {
      return "Choose language";
    }
    return AppLocalizations.of(context).translate(widget.chooseLangKey);
  }
}
