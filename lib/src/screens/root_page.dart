import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/common/build_context_singleton.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/screens/home_page.dart';
import 'package:qr_scanner/src/screens/login/login_page.dart';
import 'package:qr_scanner/src/widgets/color_loader.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setContextToSingleton(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ColorLoader();
    } else {
      return Consumer<AppGeneralNotifier>(
        builder: (context, appGeneralNotifier, _) {
          return appGeneralNotifier.getLogged() != null
              ? appGeneralNotifier.getLogged() ? HomePage() : LoginPage()
              : ColorLoader();
        },
      );
    }
  }

  _setContextToSingleton(context) {
    BuildContextSingleton.context = context;
    setState(() => _isLoading = false);
  }
}
