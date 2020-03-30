import 'package:flutter/material.dart';
import 'package:qr_scanner/src/common/analytics_singleton.dart';
import 'package:qr_scanner/src/helpers/navigations/dismiss_keyboard.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/screens/home_page.dart';
import 'package:qr_scanner/src/screens/login/login_page.dart';
import 'package:qr_scanner/src/screens/root_page.dart';
import 'package:provider/provider.dart' as provider;

class QrCodeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider<AppGeneralNotifier>(
          create: (_) => AppGeneralNotifier(),
        ),
        provider.ChangeNotifierProvider<ThemeChangeNotifier>(
          create: (_) => ThemeChangeNotifier(),
        ),
        provider.ChangeNotifierProvider<LanguageChangeNotifier>(
          create: (_) => LanguageChangeNotifier(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Scanner',
        theme: ThemeData(fontFamily: 'Video'),
        home: RootPage(),
        routes: <String, WidgetBuilder>{
          '/root': (BuildContext context) => RootPage(),
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
        },
        navigatorObservers: [
          AnalyticSingleton.observer,
          DismissKeyboardNavigationObserver(),
        ],
      ),
    );
  }
}
