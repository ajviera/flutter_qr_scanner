import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';

class ShowSnackBar {
  String text;
  BuildContext context;
  void show({String text, BuildContext context, bool isError}) {
    this.text = text;
    this.context = context;
    if (isError == null || isError) {
      _showError();
    } else {
      _showSuccess();
    }
  }

  _showSuccess() {
    Flushbar(
      title: ProviderManager.languageChangeNotifier().getStrings().appTitle,
      message: this.text,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: ProviderManager.themeChangeNotifier().getTheme().primaryColor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      backgroundGradient:
          ProviderManager.themeChangeNotifier().getTheme().buttonGradient,
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(Icons.check_circle, color: Colors.green),
      // mainButton: FlatButton(
      //   onPressed: () {},
      //   child: Text(
      //     "CLAP",
      //     style: TextStyle(color: Colors.amber),
      //   ),
      // ),
      // showProgressIndicator: true,
      // progressIndicatorBackgroundColor: Colors.red,
      titleText: Text(
        ProviderManager.languageChangeNotifier().getStrings().appTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: "ShadowsIntoLightTwo",
        ),
      ),
      messageText: Text(
        this.text,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontFamily: "ShadowsIntoLightTwo",
        ),
      ),
    ).show(this.context);
  }

  _showError() {
    Flushbar(
      title: ProviderManager.languageChangeNotifier().getStrings().appTitle,
      message: this.text,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: ProviderManager.themeChangeNotifier().getTheme().primaryColor,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      // backgroundGradient: LinearGradient(
      //   colors: [Colors.blueGrey, Colors.black],
      // ),
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(
        Icons.sms_failed,
        color: Colors.redAccent,
      ),
      // mainButton: FlatButton(
      //   onPressed: () {},
      //   child: Text(
      //     "CLAP",
      //     style: TextStyle(color: Colors.amber),
      //   ),
      // ),
      // showProgressIndicator: true,
      // progressIndicatorBackgroundColor: Colors.red,
      titleText: Text(
        ProviderManager.languageChangeNotifier().getStrings().appTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: ProviderManager.themeChangeNotifier().getTheme().primaryColor,
          fontFamily: "ShadowsIntoLightTwo",
        ),
      ),
      messageText: Text(
        this.text,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.red,
          fontFamily: "ShadowsIntoLightTwo",
        ),
      ),
    ).show(this.context);
  }
}
