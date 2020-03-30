import 'package:flutter/material.dart';
import 'package:qr_scanner/src/interactors/provider_manager.dart';

class ItemQr extends StatelessWidget {
  const ItemQr({
    @required this.context,
    @required this.text,
    @required this.heightPercent,
  });
  final BuildContext context;
  final String text;
  final double heightPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProviderManager.themeChangeNotifier()
            .getTheme()
            .cardBackgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * this.heightPercent,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
