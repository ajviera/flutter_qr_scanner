import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/interactors/vibrate.dart';
import 'package:qr_scanner/src/providers/app_change_notifier.dart';
import 'package:qr_scanner/src/providers/language_change_notifier.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/screens/user/user_details_page.dart';
import 'package:qr_scanner/src/services/auth.dart';
import 'package:qr_scanner/src/themes/ui_dark.dart';
import 'package:qr_scanner/src/widgets/user_circle_avatar.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({@required this.drawerOptions});

  final List<Widget> drawerOptions;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  bool _isSelected;
  FirebaseUser user;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _isSelected =
          Provider.of<ThemeChangeNotifier>(context).getTheme().runtimeType ==
              UiDark;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<AppGeneralNotifier>(context).getCurrentUser();
    });
    return Drawer(
      child: Container(
        color: Provider.of<ThemeChangeNotifier>(context)
            .getTheme()
            .drawerBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _header(context),
            Column(children: widget.drawerOptions),
            Expanded(child: SizedBox()),
            IconButton(
              icon: Image(
                image: Provider.of<ThemeChangeNotifier>(context)
                    .getTheme()
                    .themeIcon,
              ),
              color: Provider.of<ThemeChangeNotifier>(context)
                  .getTheme()
                  .logoutColor,
              onPressed: () {
                if (_isSelected) {
                  Provider.of<ThemeChangeNotifier>(context).light();
                } else {
                  Provider.of<ThemeChangeNotifier>(context).dark();
                }
                Vibrate().execute();
                _isSelected = !_isSelected;
              },
            ),
            Divider(
              color: Provider.of<ThemeChangeNotifier>(context)
                  .getTheme()
                  .logoutColor,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ListTile(
                title: Text(
                  Provider.of<LanguageChangeNotifier>(context)
                      .getStrings()
                      .logout,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Provider.of<ThemeChangeNotifier>(context)
                        .getTheme()
                        .logoutColor,
                    fontSize: 16.0,
                  ),
                ),
                trailing: Icon(
                  Icons.exit_to_app,
                  color: Provider.of<ThemeChangeNotifier>(context)
                      .getTheme()
                      .logoutColor,
                ),
                onTap: () => _signOut(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Provider.of<ThemeChangeNotifier>(context)
            .getTheme()
            .drawerHeaderBackgroundColor,
      ),
      // onDetailsPressed: () => showUserDetails(context),
      currentAccountPicture: UserCircleAvatar(user: user),
      accountName: Text(
        user.displayName != null ? user.displayName : '',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      accountEmail: Text(
        user.email,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  void showUserDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(user: this.user),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await Auth().signOut();
      Provider.of<AppGeneralNotifier>(context).logout();
    } catch (e) {
      print(e.toString());
    }
  }
}
