import 'package:flutter/material.dart';
import 'package:qr_scanner/src/widgets/custom_text.dart';

class ContentText extends StatelessWidget {
  const ContentText({
    Key key,
    @required this.qrCodeResult,
  }) : super(key: key);

  final String qrCodeResult;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        CustomText(text: qrCodeResult),
      ],
    );
  }
}
