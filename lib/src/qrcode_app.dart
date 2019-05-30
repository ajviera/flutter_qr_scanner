import 'package:flutter/material.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/screens/root_page.dart';
import 'package:provider/provider.dart';

class QrCodeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppGeneralNotifier>(
          builder: (_) => AppGeneralNotifier(),
        ),
        ChangeNotifierProvider<ThemeChangeNotifier>(
          builder: (_) => ThemeChangeNotifier(),
        ),
        ChangeNotifierProvider<LanguageChangeNotifier>(
          builder: (_) => LanguageChangeNotifier(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Scanner',
        theme: ThemeData(fontFamily: 'Video'),
        home: RootPage(),
      ),
    );
  }
}
