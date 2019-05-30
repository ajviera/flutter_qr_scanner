import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';

mixin KeyboardListener<T extends StatefulWidget> on State<T> {
  Map<String, FocusNode> _map = Map();
  bool displayDoneButton = false;

  addDoneButton(String key) {
    _map[key] = FocusNode();
  }

  FocusNode getFocus(String key) {
    return _map[key];
  }

  clearFocus() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  _focusNodeListener() async {
    bool hasFocusFound = false;
    _map.values.forEach((focusNode) {
      if (focusNode.hasFocus) {
        hasFocusFound = true;
        return;
      }
    });
    _shouldRefresh(hasFocusFound);
  }

  showDoneButton() {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      left: 0.0,
      child: displayDoneButton && Platform.isIOS
          ? Container(
              height: 45.0,
              alignment: Alignment.centerRight,
              color: Color(0xFFe3e4e9),
              child: Padding(
                padding: const EdgeInsets.only(right: 7.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  onPressed: () => clearFocus(),
                  color: Provider.of<ThemeChangeNotifier>(context)
                      .getTheme()
                      .primaryColor,
                  child: Text(
                    Provider.of<LanguageChangeNotifier>(context)
                        .getStrings()
                        .acceptButton,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }

  _shouldRefresh(bool newValue) {
    if (displayDoneButton != newValue) {
      setState(() {
        displayDoneButton = newValue;
      });
    }
  }

  @override
  void initState() {
    _map.values
        .forEach((focusNode) => focusNode.addListener(_focusNodeListener));
    super.initState();
  }

  @override
  void dispose() {
    _map.values
        .forEach((focusNode) => focusNode.removeListener(_focusNodeListener));
    super.dispose();
  }
}
