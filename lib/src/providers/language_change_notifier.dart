import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:qr_scanner/src/helpers/enums/language_type.dart';
import 'package:qr_scanner/src/locales/english_strings.dart';
import 'package:qr_scanner/src/locales/locale_singleton.dart';
import 'package:qr_scanner/src/locales/spanish_strings.dart';

class LanguageChangeNotifier with ChangeNotifier {
  LanguageChangeNotifier() {
    _loadData();
  }

  getStrings() => LocaleSingleton.strings;

  void _loadData() {
    if (PrefsSingleton.prefs.getBool('languageSpanish') != null) {
      _fromSharePreferences();
    } else {
      _fromCurrentLocale();
    }
  }

  void _fromSharePreferences() {
    if (PrefsSingleton.prefs.getBool('languageSpanish')) {
      _setSpanish();
    } else {
      _setEnglish();
    }
  }

  void _fromCurrentLocale() {
    // Intl.defaultLocale = 'es_AR';
    String myLocale = Intl.getCurrentLocale();
    if (myLocale == 'es_AR') {
      _setSpanish();
    } else {
      _setEnglish();
    }
  }

  void _setSpanish() {
    LocaleSingleton.strings = SpanishStrings();
    PrefsSingleton.prefs.setBool('languageSpanish', true);
  }

  void _setEnglish() {
    LocaleSingleton.strings = EnglishStrings();
    PrefsSingleton.prefs.setBool('languageSpanish', false);
  }

  void changeLanguage(LANGUAGETYPE languageType) async {
    switch (languageType) {
      case LANGUAGETYPE.SPANISH:
        _setSpanish();
        break;
      case LANGUAGETYPE.ENGLISH:
        _setEnglish();
        break;
      default:
        _setEnglish();
        break;
    }
    notifyListeners();
  }
}
