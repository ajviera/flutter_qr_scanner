import 'package:flutter/material.dart';
import 'package:qr_scanner/src/themes/ui_theme.dart';

class UiDark extends UiTheme {
  UiDark() {
    super.primaryColor = Color(0xFF97076e);
    super.secundaryColor = Colors.grey.shade700;
    super.backgroundImage = AssetImage("assets/images/background.jpg");
    super.backgroundColor = Color(0xFF0c1a2f);
    super.appBarBackgroundColor = Color(0xFF0c1a2f);
    super.drawerBackgroundColor = Color(0xFF0a1222);
    super.drawerHeaderBackgroundColor = Color(0xFF0a1222);
    super.scanQRPageWords = Colors.white;
    super.cardBackgroundColor = Color(0xFF19202e);
    super.buttonGradient = LinearGradient(
      colors: <Color>[Color(0xFFbc0281), Color(0xFF6d075e)],
    );
    super.themeIcon = AssetImage('assets/icons/moon_icon.png');
    super.scanQrImage = AssetImage('assets/images/main_logo_white.png');
    super.invertedScanQrImage = AssetImage('assets/images/main_logo.png');
    super.scanQrImageBackgroundColor = Colors.white;
    super.logoutColor = Colors.white;
  }
}
