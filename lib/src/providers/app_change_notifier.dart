import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/src/common/prefs_singleton.dart';
import 'package:qr_scanner/src/interactors/remove_user_data.dart';
import 'package:qr_scanner/src/services/auth.dart';

class AppGeneralNotifier with ChangeNotifier {
  FirebaseUser _user;
  bool _isLogged;

  AppGeneralNotifier() {
    PrefsSingleton.prefs.getString('userUid') != null ? login() : logout();
  }

  getLogged() => _isLogged;
  setLoggedState(bool isLogged) => _isLogged = isLogged;

  getCurrentUser() {
    if (this._user == null) _getUser();
    return this._user;
  }

  _getUser() async {
    Auth().currentUser().then((FirebaseUser userResponse) {
      PrefsSingleton.prefs.setString('userUid', userResponse.uid);
      this._user = userResponse;
    });
  }

  void login() async {
    _isLogged = true;
    await _getUser();
    notifyListeners();
  }

  void logout() {
    _isLogged = false;
    RemoveUserData().execute();
    notifyListeners();
  }
}
