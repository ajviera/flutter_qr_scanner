import 'package:flutter/material.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            width: MediaQuery.of(context).size.height * 0.33,
            child: Image(
              image: ProviderManager.themeChangeNotifier()
                  .getTheme()
                  .invertedScanQrImage,
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.height * 0.40,
          child: Text(
            ProviderManager.languageChangeNotifier().getStrings().appTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  ProviderManager.themeChangeNotifier().getTheme().primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 45.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.height * 0.40,
            child: Text(
              ProviderManager.languageChangeNotifier().getStrings().version,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ProviderManager.themeChangeNotifier()
                    .getTheme()
                    .scanQrImageBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
