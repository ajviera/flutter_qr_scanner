import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:vibration/vibration.dart';

class Vibrate {
  void execute() async {
    if (PrefsSingleton.prefs.getBool('vibration') != null &&
        PrefsSingleton.prefs.getBool('vibration') &&
        await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }
}
