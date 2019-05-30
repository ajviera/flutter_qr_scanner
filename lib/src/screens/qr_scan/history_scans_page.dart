import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/helpers/enums/scan_type.dart';
import 'package:qr_scanner/src/helpers/navigations/navigator.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/screens/qr_scan/scan_detail_page.dart';
import 'package:qr_scanner/src/services/repositories/qr_code_storage.dart';
import 'package:qr_scanner/src/widgets/color_loader_popup.dart';

class HistoryScansPage extends StatefulWidget {
  final Function showSnackBar;
  HistoryScansPage({
    Key key,
    this.showSnackBar,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryScansPageState();
}

class _HistoryScansPageState extends State<HistoryScansPage> {
  QrCodeStorage qrCodeStorage;
  Stream<QuerySnapshot> qrCodeSnapshots;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      qrCodeStorage = QrCodeStorage.forUser(
        user: Provider.of<AppGeneralNotifier>(context).getCurrentUser(),
      );
      setState(() {
        qrCodeSnapshots = qrCodeStorage.list();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: qrCodeSnapshots,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return ColorLoaderPopup();
          if (snapshot.data.documents.length == 0) return _emptyBody();
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _buildItem(snapshot.data.documents[index]);
            },
          );
        },
      ),
    );
  }

  Widget _emptyBody() {
    return Center(
      child: Text(
        Provider.of<LanguageChangeNotifier>(context).getStrings().dontHaveScans,
        style: TextStyle(
          fontSize: 22.0,
          color: Provider.of<ThemeChangeNotifier>(context)
              .getTheme()
              .cardBackgroundColor,
        ),
      ),
    );
  }

  Widget _buildItem(DocumentSnapshot document) {
    return GestureDetector(
      onTap: () => _openDetail(document),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SizedBox(
          height: 70.0,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Provider.of<ThemeChangeNotifier>(context)
                .getTheme()
                .cardBackgroundColor,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 7.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        textFromScanType(_type(document['qr_code'])),
                        style: TextStyle(
                          color: Color(0xFF5953ad),
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(
                        width: 225.0,
                        child: Text(
                          document['qr_code'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Center(
                    child: Icon(
                      Icons.navigate_next,
                      size: 30.0,
                      color: Color(0xFFd8d8d8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDetail(DocumentSnapshot document) {
    GeneralNavigator(
      context,
      ScanDetailPage(
        type: _type(document['qr_code']),
        id: document['id'],
        qrCode: document['qr_code'],
        qrCodeStorage: qrCodeStorage,
      ),
    ).navigate();
  }

  SCANTYPE _type(String qrCode) {
    if (qrCode.contains('VCARD')) {
      return SCANTYPE.VCARD;
    } else if (qrCode.contains('http')) {
      return SCANTYPE.WEB;
    }
    return SCANTYPE.TEXT;
  }
}
