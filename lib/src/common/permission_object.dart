import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';

EasyPermissionValidator permissionValidator({BuildContext context}) {
  return EasyPermissionValidator(
    context: context,
    appName: ProviderManager.languageChangeNotifier().getStrings().title,
    cancelText: ProviderManager.languageChangeNotifier().getStrings().cancel,
    goToSettingsText:
        ProviderManager.languageChangeNotifier().getStrings().goToSettings,
    permissionSettingsMessage: ProviderManager.languageChangeNotifier()
        .getStrings()
        .permissionSettingsMessage,
    customDialog: _customPopup(context),
  );
}

_customPopup(BuildContext context) {
  return AlertDialog(
    title: Center(
      child: Text(
        ProviderManager.languageChangeNotifier().getStrings().title,
        style: TextStyle(
          color: ProviderManager.themeChangeNotifier().getTheme().primaryColor,
          fontSize: 23.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            ProviderManager.languageChangeNotifier()
                .getStrings()
                .permissionSettingsMessage,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 18.0),
          ),
        )
      ],
    ),
    actions: <Widget>[
      FlatButton(
        child: Text(ProviderManager.languageChangeNotifier()
            .getStrings()
            .cancel
            .toUpperCase()),
        onPressed: () => _closePopup(context),
      ),
      FlatButton(
        child: Text(
            ProviderManager.languageChangeNotifier().getStrings().goToSettings),
        onPressed: () => _openPermissionSettings(context),
      ),
    ],
  );
}

_openPermissionSettings(context) async {
  await PermissionHandler().openAppSettings();
  _closePopup(context);
}

_closePopup(context) => Navigator.of(context).pop();
