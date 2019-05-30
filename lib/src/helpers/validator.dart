import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/common/general_regex.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';

class Validator {
  BuildContext context;

  Validator({BuildContext context}) {
    this.context = context;
  }

  String emailValidator(String input) {
    if (input.isEmpty) {
      return Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .emailEmptyError;
    } else if (!GeneralRegex.regexEmail.hasMatch(input)) {
      return Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .emailError;
    } else {
      return null;
    }
  }

  String passwordValidator(String input) {
    if (input.isEmpty) {
      return Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .passwordError;
    } else if (!GeneralRegex.regexPassword.hasMatch(input)) {
      return Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .passwordErrorBadFormat;
    } else {
      return null;
    }
  }

  String phoneValidator(String input) {
    if (input.isEmpty) {
      return Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .phoneError;
    } else if (!GeneralRegex.regexPhone.hasMatch(input)) {
      return Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .phoneErrorBadFormat;
    } else {
      return null;
    }
  }
}
