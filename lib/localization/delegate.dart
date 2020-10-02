import 'dart:async';

import 'package:flutter_common/localization/localization.dart';
import 'package:flutter/material.dart';

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  final List<Locale> locales;
  final String path;

  const LocalizationDelegate(this.locales, this.path);

  @override
  bool isSupported(Locale locale) {
    for (var sup in locales) {
      if (sup.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<Localization> load(Locale locale) async {
    if (locale == null) {
      locale = locales[0];
    }
    Localization localizations = Localization(locales, path);
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(LocalizationDelegate old) {
    return false;
  }
}
