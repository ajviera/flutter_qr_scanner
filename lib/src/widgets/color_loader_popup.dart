import 'package:flutter/material.dart';
import 'package:qr_scanner/src/widgets/color_loader.dart';

class ColorLoaderPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: 80.0,
          width: 80.0,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(70.0)),
            ),
            color: Colors.white,
            child: Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: ColorLoader(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
