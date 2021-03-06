import 'package:flutter/material.dart';
import 'package:qr_scanner/src/common/permission_object.dart';
import 'package:qr_scanner/src/helpers/enums/scan_type.dart';
import 'package:qr_scanner/src/helpers/show_flush_bar.dart';
import 'package:qr_scanner/src/interactors/save_contact.dart';
import 'package:qr_scanner/src/interactors/vibrate.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';
import 'package:qr_scanner/src/services/repositories/qr_code_storage.dart';
import 'package:qr_scanner/src/widgets/item_qr.dart';
import 'package:qr_scanner/src/widgets/loading_popup.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanDetailPage extends StatefulWidget {
  ScanDetailPage({
    Key key,
    @required this.type,
    @required this.id,
    @required this.qrCode,
    @required this.qrCodeStorage,
  }) : super(key: key);

  final SCANTYPE type;
  final String id;
  final String qrCode;
  final QrCodeStorage qrCodeStorage;

  _ScanDetailPageState createState() => _ScanDetailPageState();
}

class _ScanDetailPageState extends State<ScanDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ProviderManager.themeChangeNotifier().getTheme().backgroundColor,
      appBar: _appBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.0),
          child: ItemQr(
            context: context,
            text: widget.qrCode,
            heightPercent: 0.70,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: ProviderManager.themeChangeNotifier()
                    .getTheme()
                    .scanQrImageBackgroundColor,
                size: 40.0,
              ),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              tooltip: ProviderManager.languageChangeNotifier()
                  .getStrings()
                  .deleteFavourite,
              onPressed: () => _deleteQrCode(),
            ),
            _actionButton(),
          ],
        ),
      ],
    );
  }

  Widget _actionButton() {
    switch (widget.type) {
      case SCANTYPE.TEXT:
        return SizedBox();
      case SCANTYPE.VCARD:
        return IconButton(
          icon: Icon(
            Icons.import_contacts,
            color: ProviderManager.themeChangeNotifier()
                .getTheme()
                .scanQrImageBackgroundColor,
            size: 40.0,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          tooltip:
              ProviderManager.languageChangeNotifier().getStrings().addContact,
          onPressed: () => _saveContact(widget.qrCode),
        );
      case SCANTYPE.WEB:
        return IconButton(
          icon: Icon(
            Icons.open_in_browser,
            color: ProviderManager.themeChangeNotifier()
                .getTheme()
                .scanQrImageBackgroundColor,
            size: 40.0,
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          tooltip:
              ProviderManager.languageChangeNotifier().getStrings().launchUrl,
          onPressed: () => _launchURL(widget.qrCode),
        );
    }
    return SizedBox();
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: ProviderManager.themeChangeNotifier()
          .getTheme()
          .appBarBackgroundColor,
      // leading: Builder(
      //   builder: (context) => IconButton(
      //         splashColor: Colors.transparent,
      //         highlightColor: Colors.transparent,
      //         icon: Icon(Icons.menu),
      //         onPressed: () => _scaffoldKey.currentState.openDrawer(),
      //       ),
      // ),
      elevation: 0.0,
      title: SafeArea(
        child: Text(
          textFromScanType(widget.type),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _saveContact(String text) async {
    var result = await permissionValidator(context: context).contacts();
    if (result) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => LoadingPopup(
          future: () async {
            return await SaveContactFromVCARD.initializeDefault(text);
          },
          successFunction: () => {},
          failFunction: () => {},
        ),
      ).then((result) {
        switch (result) {
          case SaveContactStatus.OK:
            return ShowSnackBar().show(
              text: ProviderManager.languageChangeNotifier()
                  .getStrings()
                  .contactSaved,
              context: context,
              isError: false,
            );
          case SaveContactStatus.ERROR:
            return ShowSnackBar().show(
              text: ProviderManager.languageChangeNotifier()
                  .getStrings()
                  .contactNotSave,
              context: context,
              isError: true,
            );
          case SaveContactStatus.EXIST:
            return ShowSnackBar().show(
              text: ProviderManager.languageChangeNotifier()
                  .getStrings()
                  .contactNotSave,
              context: context,
              isError: true,
            );
        }
      });
    }
  }

  _deleteQrCode() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            ProviderManager.languageChangeNotifier().getStrings().areYouSure,
          ),
          content: Text(
            ProviderManager.languageChangeNotifier()
                .getStrings()
                .removeScanMessage,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                ProviderManager.languageChangeNotifier().getStrings().no,
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                ProviderManager.languageChangeNotifier().getStrings().yes,
              ),
            ),
          ],
        );
      },
    ).then((result) {
      if (result) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => LoadingPopup(
            future: () async {
              return await widget.qrCodeStorage.delete(widget.id);
            },
            successFunction: () => {},
            failFunction: () => {},
          ),
        ).then((_) {
          Vibrate().execute();
          Navigator.pop(context, true);
        });
      }
    });
  }

  _launchURL(String text) async {
    if (await canLaunch(text)) {
      await launch(text);
    } else {
      ShowSnackBar().show(
        text: ProviderManager.languageChangeNotifier()
                .getStrings()
                .launchUrlError +
            text,
        context: context,
        isError: true,
      );
    }
  }
}
