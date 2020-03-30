import 'package:flutter/material.dart';
import 'package:qr_scanner/src/common/general_regex.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';

class Validator {
  BuildContext context;

  Validator({BuildContext context}) {
    this.context = context;
  }

  String emailValidator(String input) {
    if (input.isEmpty) {
      return ProviderManager.languageChangeNotifier()
          .getStrings()
          .emailEmptyError;
    } else if (!GeneralRegex.regexEmail.hasMatch(input)) {
      return ProviderManager.languageChangeNotifier().getStrings().emailError;
    } else {
      return null;
    }
  }

  String passwordValidator(String input) {
    if (input.isEmpty) {
      return ProviderManager.languageChangeNotifier()
          .getStrings()
          .passwordError;
    } else if (!GeneralRegex.regexPassword.hasMatch(input)) {
      return ProviderManager.languageChangeNotifier()
          .getStrings()
          .passwordErrorBadFormat;
    } else {
      return null;
    }
  }

  String phoneValidator(String input) {
    if (input.isEmpty) {
      return ProviderManager.languageChangeNotifier().getStrings().phoneError;
    } else if (!GeneralRegex.regexPhone.hasMatch(input)) {
      return ProviderManager.languageChangeNotifier()
          .getStrings()
          .phoneErrorBadFormat;
    } else {
      return null;
    }
  }
}
