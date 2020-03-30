import 'package:flutter/material.dart';
import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:qr_scanner/src/interactors/vibrate.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';
import 'package:qr_scanner/src/locales/accepted_languages.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic> _languageSelected;
  List<Map<String, dynamic>> _languageType;
  bool isSwitched;

  @override
  void initState() {
    isSwitched = PrefsSingleton.prefs.getBool('vibration') != null
        ? PrefsSingleton.prefs.getBool('vibration')
        : false;
    super.initState();
  }

  _setLanguage() {
    _languageType = _languages();
    if (PrefsSingleton.prefs.getString('language') != null) {
      if (PrefsSingleton.prefs.getString('language') ==
          AcceptedLanguages.languages[0]) {
        _languageSelected = _languageType[0];
      } else {
        _languageSelected = _languageType[1];
      }
    } else {
      _languageSelected = _languageType[0];
    }
  }

  List<Map<String, dynamic>> _languages() {
    return [
      {
        'id': AcceptedLanguages.languages[0],
        'type': ProviderManager.languageChangeNotifier().getStrings().spanish,
      },
      {
        'id': AcceptedLanguages.languages[1],
        'type': ProviderManager.languageChangeNotifier().getStrings().english,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    _setLanguage();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _optionCard(child: _languageSelector()),
          _optionCard(child: _switchButton()),
        ],
      ),
    );
  }

  Widget _switchButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            ProviderManager.languageChangeNotifier().getStrings().vibrate,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
        Switch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
              PrefsSingleton.prefs.setBool('vibration', isSwitched);
              if (isSwitched) Vibrate().execute();
            });
          },
          activeTrackColor:
              ProviderManager.themeChangeNotifier().getTheme().primaryColor,
          inactiveTrackColor:
              ProviderManager.themeChangeNotifier().getTheme().primaryColor,
          activeColor: Colors.white,
        ),
      ],
    );
  }

  Widget _languageSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: ProviderManager.themeChangeNotifier()
              .getTheme()
              .appBarBackgroundColor,
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText:
                ProviderManager.languageChangeNotifier().getStrings().language,
            labelStyle: TextStyle(color: Colors.white),
          ),
          isEmpty: _languageSelected == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, dynamic>>(
              value: _languageSelected,
              isDense: true,
              onChanged: (Map<String, dynamic> newValue) =>
                  _changeLanguage(newValue),
              items: _languageType.map((Map<String, dynamic> value) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: value,
                  child: Text(
                    value['type'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  _changeLanguage(Map<String, dynamic> newValue) {
    setState(() => _languageSelected = newValue);
    ProviderManager.languageChangeNotifier().changeLanguage(newValue['id']);
  }

  Widget _optionCard({Widget child}) {
    return SizedBox(
      height: 70.0,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: ProviderManager.themeChangeNotifier()
            .getTheme()
            .cardBackgroundColor,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: child,
      ),
    );
  }
}
