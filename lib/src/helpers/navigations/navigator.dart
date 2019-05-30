import 'package:flutter/material.dart';
import 'package:qr_scanner/src/helpers/navigations/fade_navigaton.dart';
import 'package:qr_scanner/src/helpers/navigations/on_different_side.dart';

class GeneralNavigator {
  BuildContext context;
  var page;

  GeneralNavigator(this.context, this.page);

  navigate() async {
    final result = await Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) => this.page),
    );

    return result;
  }

  replaceNavigate() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }

  fadeNavigate() {
    Navigator.push(
      this.context,
      FadeNavigation(builder: (BuildContext context) => page),
    );
  }

  navigateFromLeft() async {
    final result = await Navigator.push(
      this.context,
      OnDifferentSide(
        builder: (context) => this.page,
        offset: Offset(-1.0, 0.0),
      ),
    );
    return result;
  }

  navigateFromBottom() {
    Navigator.push(
      this.context,
      OnDifferentSide(
        builder: (context) => this.page,
        offset: Offset(0.0, 0.0),
      ),
    );
  }
}
