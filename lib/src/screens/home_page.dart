import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/helpers/show_flush_bar.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/screens/about/about_page.dart';
import 'package:qr_scanner/src/screens/qr_scan/history_scans_page.dart';
import 'package:qr_scanner/src/screens/qr_scan/qr_scan_page.dart';
import 'package:qr_scanner/src/screens/settings/settings_page.dart';
import 'package:qr_scanner/src/widgets/home_drawer.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedDrawerIndex = 0;
  var drawerItems;

  @override
  Widget build(BuildContext context) {
    _drawerItemsOptions();
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: _appBar(),
        drawer: HomeDrawer(drawerOptions: _drawerOptions()),
        key: _scaffoldKey,
        backgroundColor: Provider.of<ThemeChangeNotifier>(context)
            .getTheme()
            .backgroundColor,
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Provider.of<ThemeChangeNotifier>(context)
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
          drawerItems[_selectedDrawerIndex].title.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return QrScanPage(showSnackBar: _showSnackBar);
      case 1:
        return HistoryScansPage(showSnackBar: _showSnackBar);
      case 2:
        return SettingsPage();
      case 3:
        return AboutPage();
      default:
        return Text("Error");
    }
  }

  _drawerItemsOptions() {
    setState(() {
      drawerItems = [
        DrawerItem(
          Provider.of<LanguageChangeNotifier>(context)
              .getStrings()
              .qrScanPageTitle,
          Icons.search,
        ),
        DrawerItem(
          Provider.of<LanguageChangeNotifier>(context)
              .getStrings()
              .historyScansPageTitle,
          Icons.history,
        ),
        DrawerItem(
          Provider.of<LanguageChangeNotifier>(context)
              .getStrings()
              .settingsPageTitle,
          Icons.settings,
        ),
        DrawerItem(
          Provider.of<LanguageChangeNotifier>(context)
              .getStrings()
              .aboutPageTitle,
          Icons.info,
        ),
      ];
    });
  }

  void _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  List<Widget> _drawerOptions() {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      drawerOptions.add(
        Container(
          color: i == _selectedDrawerIndex
              ? Color(0xFF1e2532)
              : Colors.transparent,
          child: InkWell(
            onTap: () => _onSelectItem(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    drawerItems[i].icon,
                    color:
                        i == _selectedDrawerIndex ? Colors.white : Colors.grey,
                  ),
                  Text(
                    drawerItems[i].title.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: i == _selectedDrawerIndex
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return drawerOptions;
  }

  void _showSnackBar(String text) {
    ShowSnackBar().show(text: text, context: context, isError: true);
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                Provider.of<LanguageChangeNotifier>(context)
                    .getStrings()
                    .areYouSure,
              ),
              content: Text(
                Provider.of<LanguageChangeNotifier>(context)
                    .getStrings()
                    .exitApp,
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    Provider.of<LanguageChangeNotifier>(context)
                        .getStrings()
                        .no,
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    Provider.of<LanguageChangeNotifier>(context)
                        .getStrings()
                        .yes,
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
