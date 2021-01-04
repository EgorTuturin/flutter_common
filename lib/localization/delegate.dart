import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_common/localization/localization.dart';

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  final List<Locale> locales;
  final String path;

  const LocalizationDelegate(this.locales, this.path);

  @override
  bool isSupported(Locale locale) {
    for (final sup in locales) {
      if (sup.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<Localization> load(Locale locale) async {
    locale ??= locales[0];
    final Localization localizations = Localization(locales, path);
    await localizations.load(locale);
    return localizations;
  }

  @override
  bool shouldReload(LocalizationDelegate old) {
    return false;
  }
}
