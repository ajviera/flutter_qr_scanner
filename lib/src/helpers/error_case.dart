import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/widgets/error_case_popup.dart';

errorCase(var error, BuildContext context, var injectedFunction) {
  var function;
  String errorMessage;
  if (error.toString().contains('Refresh Token has been revoked') ||
      error.toString().contains('Access Token has expired') ||
      error.toString().contains('Access Token has been revoked') ||
      error.toString().contains("Instance of 'Unauthorized'")) {
    // function = () => Provider.of<GeneralAppBloc>(context).notLogged();
    function = () => Provider.of<AppGeneralNotifier>(context).logout();
    errorMessage =
        Provider.of<LanguageChangeNotifier>(context).getStrings().sectionError;
  } else if (error.toString().contains('Failed host lookup')) {
    function = injectedFunction;
    errorMessage = Provider.of<LanguageChangeNotifier>(context)
        .getStrings()
        .connectionError;
  } else if (error.toString().contains('TimeoutException')) {
    function = injectedFunction;
    errorMessage =
        Provider.of<LanguageChangeNotifier>(context).getStrings().timeoutError;
  } else if (error.toString().toLowerCase().contains('internal server error')) {
    return null;
  } else {
    function = injectedFunction;
    errorMessage = (error.toString().split(': ').length > 1)
        ? error.toString().split(': ')[1]
        : error.toString();
  }

  SchedulerBinding.instance.addPostFrameCallback((_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        ErrorCasePopup(
          context: context,
          errorMessage: errorMessage,
          function: function,
        );
      },
    );
  });
}
