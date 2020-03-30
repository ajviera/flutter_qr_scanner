import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qr_scanner/src/interactors/vibrate.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';
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
          ProviderManager.themeChangeNotifier().getTheme().runtimeType ==
              UiDark;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = ProviderManager.appGeneralNotifier().getCurrentUser();
    });
    return Drawer(
      child: Container(
        color: ProviderManager.themeChangeNotifier()
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
                image:
                    ProviderManager.themeChangeNotifier().getTheme().themeIcon,
              ),
              color:
                  ProviderManager.themeChangeNotifier().getTheme().logoutColor,
              onPressed: () {
                if (_isSelected) {
                  ProviderManager.themeChangeNotifier().light();
                } else {
                  ProviderManager.themeChangeNotifier().dark();
                }
                Vibrate().execute();
                _isSelected = !_isSelected;
              },
            ),
            Divider(
              color:
                  ProviderManager.themeChangeNotifier().getTheme().logoutColor,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ListTile(
                title: Text(
                  ProviderManager.languageChangeNotifier().getStrings().logout,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: ProviderManager.themeChangeNotifier()
                        .getTheme()
                        .logoutColor,
                    fontSize: 16.0,
                  ),
                ),
                trailing: Icon(
                  Icons.exit_to_app,
                  color: ProviderManager.themeChangeNotifier()
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
        color: ProviderManager.themeChangeNotifier()
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
      ProviderManager.appGeneralNotifier().logout();
    } catch (e) {
      print(e.toString());
    }
  }
}
