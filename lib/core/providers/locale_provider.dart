import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr', 'FR');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['fr', 'wo', 'en'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }
}