import 'package:flutter/material.dart';
import 'package:qr_scanner/src/interactors/vibrate.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/widgets/item_qr.dart';
import 'package:qr_scanner/src/widgets/loading_popup.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/services/repositories/qr_code_storage.dart';
import 'package:qr_scanner/src/widgets/custom_sliding_up_panel.dart';
import 'package:flutter/scheduler.dart';

class ScanQRPage extends StatefulWidget {
  final Function showSnackBar;
  ScanQRPage({
    Key key,
    @required this.showSnackBar,
  }) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  PanelController _panelController = new PanelController();
  String qrCodeResult = "";
  QrCodeStorage qrCodeStorage;
  bool _isOpen = false;

  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      qrCodeStorage = QrCodeStorage.forUser(
        user: Provider.of<AppGeneralNotifier>(context).getCurrentUser(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Provider.of<LanguageChangeNotifier>(context)
                    .getStrings()
                    .scanQRPage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeChangeNotifier>(context)
                      .getTheme()
                      .scanQRPageWords,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
        _scanButton(),
        CustomSlidingUpPanel(
          panelController: _panelController,
          panelFunction: (pos) {},
          sliderContent: _sliderContent(),
        ),
      ],
    );
  }

  Widget _sliderContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ItemQr(
            context: context,
            text: qrCodeResult,
            heightPercent: 0.30,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                _saveQrCode(qrCodeResult);
                Vibrate().execute();
                setState(() => qrCodeResult = "");
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _scanButton() {
    return GestureDetector(
      onTap: () => _openCamera(),
      child: Center(
        child: AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(seconds: 1),
          height: 180.0,
          decoration: BoxDecoration(
            color: Provider.of<ThemeChangeNotifier>(context)
                .getTheme()
                .scanQrImageBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              if (_isOpen)
                for (var i = 3; i < 5; i += 1)
                  BoxShadow(
                    spreadRadius: i * 20.0,
                    blurRadius: 10.0,
                    offset: Offset(0.0, -5.0),
                    color: Provider.of<ThemeChangeNotifier>(context)
                        .getTheme()
                        .primaryColor
                        .withAlpha((255 + (i * 8)) * i),
                  )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Image(
              image: Provider.of<ThemeChangeNotifier>(context)
                  .getTheme()
                  .scanQrImage,
            ),
          ),
        ),
      ),
    );
  }

  void _openCamera() {
    if (_panelController.isPanelClosed()) {
      setState(() => _isOpen = !_isOpen);
      Future.delayed(const Duration(seconds: 1)).then((_) {
        setState(() => _isOpen = !_isOpen);
        Future.delayed(const Duration(milliseconds: 800)).then((_) async {
          Vibrate().execute();
          _scanQR();
        });
      });
    }
  }

  _saveQrCode(String qrCodeResult) async {
    if (qrCodeResult != '' && qrCodeResult != null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LoadingPopup(
              future: () async {
                return await qrCodeStorage.create(qrCodeResult);
              },
              successFunction: () => {},
              failFunction: () => {},
            ),
      ).then((_) => _panelController.close());
    } else {
      widget.showSnackBar(Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .qrSavedError);
    }
  }

  Future _scanQR() async {
    try {
      String result = await BarcodeScanner.scan();
      if (result != '' && result != null) {
        setState(() => qrCodeResult = result);
        _panelController.open();
      }
    } on FormatException {
      widget.showSnackBar(Provider.of<LanguageChangeNotifier>(context)
          .getStrings()
          .backButtonError);
    } catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        widget.showSnackBar(Provider.of<LanguageChangeNotifier>(context)
            .getStrings()
            .cameraPermissionError);
      } else {
        print(ex);
        widget.showSnackBar(Provider.of<LanguageChangeNotifier>(context)
            .getStrings()
            .unknownError);
      }
    }
  }
}
