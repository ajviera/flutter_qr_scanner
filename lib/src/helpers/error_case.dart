import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';
import 'package:qr_scanner/src/widgets/error_case_popup.dart';

errorCase(var error, BuildContext context, var injectedFunction) {
  var function;
  String errorMessage;
  if (error.toString().contains('Refresh Token has been revoked') ||
      error.toString().contains('Access Token has expired') ||
      error.toString().contains('Access Token has been revoked') ||
      error.toString().contains("Instance of 'Unauthorized'")) {
    // function = () => Provider.of<GeneralAppBloc>(context).notLogged();
    function = () => ProviderManager.appGeneralNotifier().logout();
    errorMessage =
        ProviderManager.languageChangeNotifier().getStrings().sectionError;
  } else if (error.toString().contains('Failed host lookup')) {
    function = injectedFunction;
    errorMessage =
        ProviderManager.languageChangeNotifier().getStrings().connectionError;
  } else if (error.toString().contains('TimeoutException')) {
    function = injectedFunction;
    errorMessage =
        ProviderManager.languageChangeNotifier().getStrings().timeoutError;
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
        return ErrorCasePopup(
          context: context,
          errorMessage: errorMessage,
          function: function,
        );
      },
    );
  });
}
