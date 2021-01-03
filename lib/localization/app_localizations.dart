import 'package:flutter/material.dart';
import 'package:flutter_common/localization/delegate.dart';
import 'package:flutter_common/localization/localization.dart';

String translate(BuildContext context, String key) => AppLocalizations.of(context).translate(key);

class AppLocalizations extends StatefulWidget {
  final Widget child;
  final Locale init;
  final Map<Locale, String> locales;
  final String pathToAssets;

  const AppLocalizations(
      {Key key,
      @required this.child,
      @required this.locales,
      this.pathToAssets = "install/lang/",
      this.init})
      : super(key: key);

  @override
  _AppLocalizationsState createState() {
    return _AppLocalizationsState();
  }

  static String toUtf8(String text) {
    return Localization.toUtf8(text);
  }

  static _AppLocalizationsState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedLocaleProvider>().data;
  }
}

class _AppLocalizationsState extends State<AppLocalizations> {
  Localization _localizations;

  @override
  void initState() {
    super.initState();
    _localizations = Localization(supportedLocales, widget.pathToAssets);
    load(widget.init);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedLocaleProvider(
        data: this,
        child:
            _localizations.currentDictionary == null ? const CircularProgressIndicator() : widget.child);
  }

  void load(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      await _localizations.load(locale);
    } else {
      await _localizations.load(supportedLocales.first);
    }
    _update();
  }

  String translate(String key) {
    return _localizations.translate(key);
  }

  String get currentLanguage => widget.locales[currentLocale];

  Locale get currentLocale => _localizations.currentLocale;

  List<Locale> get supportedLocales => widget.locales.keys.toList();

  List<String> get supportedLanguages => widget.locales.values.toList();

  LocalizationDelegate get delegate => _localizations.delegate;

  // private
  void _update() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _InheritedLocaleProvider extends InheritedWidget {
  final _AppLocalizationsState data;

  const _InheritedLocaleProvider({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedLocaleProvider oldWidget) {
    return true;
  }
}
