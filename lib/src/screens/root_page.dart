import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/screens/home_page.dart';
import 'package:qr_scanner/src/screens/login/login_page.dart';
import 'package:qr_scanner/src/widgets/color_loader.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppGeneralNotifier>(
      builder: (context, appGeneralNotifier, _) {
        return appGeneralNotifier.getLogged() != null
            ? appGeneralNotifier.getLogged() ? HomePage() : LoginPage()
            : ColorLoader();
      },
    );
  }
}
