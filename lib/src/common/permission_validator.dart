import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';

class PermissionValidator {
  PermissionValidator({@required this.context});

  BuildContext context;
  PermissionHandler permissionHandler = PermissionHandler();

  contacts() async {
    PermissionStatus contacts =
        await permissionHandler.checkPermissionStatus(PermissionGroup.contacts);
    if (contacts != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> state = await permissionHandler
          .requestPermissions([PermissionGroup.contacts]);
      if (state[PermissionGroup.contacts] == PermissionStatus.granted) {
        return true;
      } else {
        _showPermissionPopup();
      }
    }
    if (contacts == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  camera() async {
    PermissionStatus camera =
        await permissionHandler.checkPermissionStatus(PermissionGroup.camera);
    if (camera != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> state =
          await permissionHandler.requestPermissions([PermissionGroup.camera]);
      if (state[PermissionGroup.camera] == PermissionStatus.granted) {
        return true;
      } else {
        _showPermissionPopup();
      }
    }
    if (camera == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  photos() async {
    PermissionStatus photos =
        await permissionHandler.checkPermissionStatus(PermissionGroup.photos);
    if (photos != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> state =
          await permissionHandler.requestPermissions([PermissionGroup.photos]);
      if (state[PermissionGroup.photos] == PermissionStatus.granted) {
        return true;
      } else {
        _showPermissionPopup();
      }
    }
    if (photos == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  sms() async {
    // if (Platform.isAndroid) {
    //   PermissionStatus sms =
    //       await permissionHandler.checkPermissionStatus(PermissionGroup.sms);
    //   if (sms != PermissionStatus.granted) {
    //     Map<PermissionGroup, PermissionStatus> state =
    //         await permissionHandler.requestPermissions([PermissionGroup.sms]);
    //     if (state[PermissionGroup.sms] == PermissionStatus.granted) {
    //       return true;
    //     } else {
    //       _showPermissionPopup();
    //     }
    //   }
    //   if (sms == PermissionStatus.granted) {
    //     return true;
    //   }
    //   return false;
    // }
    return true;
  }

  _showPermissionPopup() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Center(
              child: Text(
                Provider.of<LanguageChangeNotifier>(context).getStrings().title,
                style: TextStyle(
                  color: Provider.of<ThemeChangeNotifier>(context)
                      .getTheme()
                      .primaryColor,
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
                    Provider.of<LanguageChangeNotifier>(context)
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
                child: Text(Provider.of<LanguageChangeNotifier>(context)
                    .getStrings()
                    .cancel
                    .toUpperCase()),
                onPressed: () => _closePopup(),
              ),
              FlatButton(
                child: Text(Provider.of<LanguageChangeNotifier>(context)
                    .getStrings()
                    .goToSettings),
                onPressed: () => _openPermissionSettings(),
              )
            ],
          ),
    );
  }

  _openPermissionSettings() async {
    await PermissionHandler().openAppSettings();
    _closePopup();
  }

  _closePopup() {
    Navigator.of(context).pop();
  }
}
