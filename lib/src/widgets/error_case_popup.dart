import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/widgets/custom_raised_button.dart';

class ErrorCasePopup extends StatelessWidget {
  ErrorCasePopup({
    @required this.context,
    @required this.errorMessage,
    this.function,
  });
  final BuildContext context;
  final String errorMessage;
  final function;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: SizedBox(
            height: 300.0,
            width: MediaQuery.of(context).size.width,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: screenSize.width * 0.60,
                          height: screenSize.height * 0.08,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        this.errorMessage,
                        maxLines: 6,
                        style: TextStyle(fontSize: 15.0, color: Colors.red),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomRaisedButton(
                      buttonColor: Provider.of<ThemeChangeNotifier>(context)
                          .getTheme()
                          .primaryColor,
                      textColor: Colors.white,
                      function: () => _back(),
                      text: Provider.of<LanguageChangeNotifier>(context)
                          .getStrings()
                          .acceptButton,
                      context: context,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _back() {
    if (this.function != null) this.function();

    Navigator.pop(context, false);
  }
}
