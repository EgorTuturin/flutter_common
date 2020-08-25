import 'dart:async';
import 'dart:convert';

import 'package:fastotv_common/localization/delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Localization {
  final List<Locale> locales;
  final String path;
  Locale _locale;
  LocalizationsDelegate<Localization> _delegate;
  Map<String, String> _localizedStrings;

  Localization(this.locales, this.path) : _delegate = LocalizationDelegate(locales, path) {
    _locale = locales[0];
  }

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static String toUtf8(String data) {
    String _output;
    try {
      _output = utf8.decode(data.codeUnits);
    } on FormatException catch (e) {
      print('error caught: $e');
      _output = data;
    }
    return _output;
  }

  Map<String, String> get currentDictionary => _localizedStrings;

  Locale get currentLocale => _locale;

  String translate(String key) => _localizedStrings[key];

  LocalizationsDelegate<Localization> get delegate => _delegate;

  Future<bool> load(Locale locale) async {
    if (locale == null) {
      return false;
    }
    // Load the language JSON file from the "lang" folder
    String path = '${this.path}${locale.languageCode}.json';
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    _locale = locale;
    return true;
  }
}
