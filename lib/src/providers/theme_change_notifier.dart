import 'package:flutter/material.dart';
import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:qr_scanner/src/themes/ui_dark.dart';
import 'package:qr_scanner/src/themes/ui_light.dart';
import 'package:qr_scanner/src/themes/ui_theme.dart';

class ThemeChangeNotifier with ChangeNotifier {
  UiTheme themeUI;

  ThemeChangeNotifier() {
    if (PrefsSingleton.prefs.getBool('darkTheme') == null) {
      PrefsSingleton.prefs.setBool('darkTheme', true);
    }
    themeUI = PrefsSingleton.prefs.getBool('darkTheme') ? UiDark() : UiLight();
  }

  UiTheme getTheme() => themeUI;
  setThemeState(UiTheme themeUI) => themeUI = themeUI;

  void light() async {
    themeUI = UiLight();
    PrefsSingleton.prefs.setBool('darkTheme', false);
    notifyListeners();
  }

  void dark() {
    themeUI = UiDark();
    PrefsSingleton.prefs.setBool('darkTheme', true);
    notifyListeners();
  }
}
