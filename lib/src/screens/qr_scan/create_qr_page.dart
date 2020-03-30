import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';
import 'package:qr_scanner/src/interactors/vibrate.dart';
import 'package:qr_scanner/src/widgets/raised_gradient_button.dart';

class CreateQRPage extends StatefulWidget {
  final Function showSnackBar;
  CreateQRPage({
    Key key,
    @required this.showSnackBar,
  }) : super(key: key);

  _CreateQRPageState createState() => _CreateQRPageState();
}

class _CreateQRPageState extends State<CreateQRPage> {
  TextEditingController _textController = TextEditingController();
  FocusNode messageFocusNode;
  String _qrText;

  @override
  void initState() {
    messageFocusNode = FocusNode();
    super.initState();
  }

  void _resetTextFocus() {
    messageFocusNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _resetTextFocus(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ProviderManager.languageChangeNotifier()
                        .getStrings()
                        .createQRPage,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ProviderManager.themeChangeNotifier()
                          .getTheme()
                          .scanQRPageWords,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _textArea(),
                  _createQrButton(),
                  _qrCode(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: ProviderManager.themeChangeNotifier()
              .getTheme()
              .cardBackgroundColor,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            focusNode: messageFocusNode,
            controller: _textController,
            maxLength: 70,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              counterStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
      ),
    );
  }

  Widget _createQrButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
      child: RaisedGradientButton(
        key: Key('createQr'),
        child: Text(
          ProviderManager.languageChangeNotifier().getStrings().createQRPage,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        width: 120.0,
        onPressed: () {
          Vibrate().execute();
          setState(() => _qrText = _textController.text);
        },
        gradient:
            ProviderManager.themeChangeNotifier().getTheme().buttonGradient,
      ),
    );
  }

  Widget _qrCode() {
    return Container(
      decoration: BoxDecoration(
        color: ProviderManager.themeChangeNotifier()
            .getTheme()
            .cardBackgroundColor,
        border: Border.all(
          color: ProviderManager.themeChangeNotifier()
              .getTheme()
              .cardBackgroundColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: _qrText == null
          ? SizedBox(height: 200.0, width: 200.0)
          : QrImage(
              data: _qrText,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
    );
  }
}
