import 'package:flutter/material.dart';
import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:qr_scanner/src/locales/english_strings.dart';
import 'package:qr_scanner/src/locales/spanish_strings.dart';
import 'dart:ui' as ui;
import 'package:qr_scanner/src/locales/strings.dart';

class LanguageChangeNotifier with ChangeNotifier {
  Strings language;

  LanguageChangeNotifier() {
    _loadData();
  }

  Strings getStrings() => language;

  void _loadData() {
    if (PrefsSingleton.prefs.getString('language') != null) {
      _fromSharePreferences();
    } else {
      _fromCurrentLocale();
    }
  }

  void _fromSharePreferences() {
    changeLanguage(PrefsSingleton.prefs.getString('language'));
  }

  void _fromCurrentLocale() {
    changeLanguage(ui.window.locale.languageCode);
  }

  void changeLanguage(String languageType) async {
    _setLanguage(languageType);
    notifyListeners();
  }

  void _setLanguage(String languageType) {
    PrefsSingleton.prefs.setString('language', languageType);
    switch (languageType) {
      case 'es':
        language = SpanishStrings();
        break;
      case 'en':
        language = EnglishStrings();
        break;
      default:
        language = EnglishStrings();
        break;
    }
  }
}
