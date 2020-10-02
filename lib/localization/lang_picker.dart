import 'package:flutter_common/base/controls/tv_controls.dart';
import 'package:flutter_common/localization/app_localizations.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    if (widget.type == 0) {
      return _settings();
    } else if (widget.type == 1) {
      return _login();
    }
    return SizedBox();
  }

  void onEnter(FocusNode node) {
    _showAlertDialog();
  }

  void _showAlertDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              contentPadding: EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
              title: Text(_chooseLanguage),
              children: <Widget>[
                SingleChildScrollView(
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: new List<Widget>.generate(supportedLocales.length, _dialogItem)))
              ]);
        });
  }

  Widget _dialogItem(int index) {
    String text = supportedLanguages[index];
    Locale locale = supportedLocales[index];
    return RadioListTile<Locale>(
        activeColor: Theme.of(context).accentColor,
        value: locale,
        title: Text(text),
        groupValue: AppLocalizations.of(context).currentLocale,
        onChanged: (Locale value) async {
          AppLocalizations.of(context).load(locale);
          widget.onChanged?.call(locale);
          Navigator.of(context).pop();
        });
  }

  Widget _settings() {
    return ListTile(
        leading: Icon(Icons.language), title: Text(_language), subtitle: Text(_languageName), onTap: _showAlertDialog);
  }

  Widget _login() {
    return Focus(
        focusNode: FocusNode(),
        onKey: (node, event) {
          return nodeAction(FocusScope.of(context), node, event);
        },
        child: FlatButton(
            onPressed: _showAlertDialog,
            child: Opacity(
                opacity: 0.5,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.language), SizedBox(width: 16), Text(_languageName)]))));
  }

  List<Locale> get supportedLocales {
    return AppLocalizations.of(context).supportedLocales;
  }

  List<String> get supportedLanguages {
    return AppLocalizations.of(context).supportedLanguages;
  }

  int currentLanguageIndex() {
    return supportedLocales.indexOf(AppLocalizations.of(context).currentLocale) ?? 0;
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
