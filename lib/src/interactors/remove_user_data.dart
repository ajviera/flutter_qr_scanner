import 'package:qr_scanner/src/common/prefs_singleton.dart';

class RemoveUserData {
  void execute() {
    _removeUserData();
  }

  _removeUserData() {
    PrefsSingleton.prefs.remove('darkTheme');
    PrefsSingleton.prefs.remove('userUid');
    PrefsSingleton.prefs.remove('languageSpanish');
    PrefsSingleton.prefs.remove('vibration');
  }
}
