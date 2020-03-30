import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/src/common/analytics_singleton.dart';
import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/qrcode_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);

  AnalyticSingleton.analytics = FirebaseAnalytics();
  AnalyticSingleton.observer =
      FirebaseAnalyticsObserver(analytics: AnalyticSingleton.analytics);

  PrefsSingleton.prefs = await SharedPreferences.getInstance();

  runApp(QrCodeApp());
}
