import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/qrcode_app.dart';

void main() async {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);

  PrefsSingleton.prefs = await SharedPreferences.getInstance();

  runApp(QrCodeApp());
}
