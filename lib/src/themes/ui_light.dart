import 'package:flutter/material.dart';
import 'package:qr_scanner/src/themes/ui_theme.dart';

class UiLight extends UiTheme {
  UiLight() {
    super.primaryColor = Color(0xFF97076e);
    super.secundaryColor = Colors.grey.shade700;
    super.backgroundImage = AssetImage("assets/images/background.jpg");
    super.backgroundColor = Colors.white;
    super.appBarBackgroundColor = Color(0xFF0c1a2f);
    super.scanQRPageWords = Color(0xFF0c1a2f);
    super.drawerBackgroundColor = Colors.white;
    super.drawerHeaderBackgroundColor = Color(0xFF0a1222);
    super.cardBackgroundColor = Color(0xFF19202e);
    super.buttonGradient = LinearGradient(
      colors: <Color>[Color(0xFFbc0281), Color(0xFF6d075e)],
    );
    super.themeIcon = AssetImage('assets/icons/sun_icon.png');
    super.scanQrImage = AssetImage('assets/images/main_logo.png');
    super.invertedScanQrImage = AssetImage('assets/images/main_logo_white.png');
    super.scanQrImageBackgroundColor = Color(0xFF0c1a2f);
    super.logoutColor = Color(0xFF0c1a2f);
  }
}
