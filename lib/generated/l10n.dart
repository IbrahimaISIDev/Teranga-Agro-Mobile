import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null, 'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static const supportedLocales = [
    Locale('fr'),
  ];

  String get addParcelle => Intl.message(
    'Ajouter une parcelle',
    name: 'addParcelle',
    desc: 'Texte pour le bouton d\'ajout de parcelle',
  );

  String get audioInstructions => Intl.message(
    'Instructions audio',
    name: 'audioInstructions',
    desc: 'Libellé pour les instructions audio',
  );

  String get nomLabel => Intl.message(
    'Nom',
    name: 'nomLabel',
    desc: 'Label du champ nom',
  );

  String get surfaceLabel => Intl.message(
    'Surface',
    name: 'surfaceLabel',
    desc: 'Label du champ surface',
  );

  String get geolocationLabel => Intl.message(
    'Localisation',
    name: 'geolocationLabel',
    desc: 'Label du champ de géolocalisation',
  );

  String get saveButton => Intl.message(
    'Enregistrer',
    name: 'saveButton',
    desc: 'Texte du bouton de sauvegarde',
  );

  String get offlineMessage => Intl.message(
    'Aucune connexion internet détectée',
    name: 'offlineMessage',
    desc: 'Message affiché quand l\'application est hors ligne',
  );

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      _current = instance;
      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = maybeOf(context);
    assert(instance != null, 'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  @override
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  @override
  bool isSupported(Locale locale) => supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
