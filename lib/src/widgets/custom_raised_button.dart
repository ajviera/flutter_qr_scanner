import 'package:flutter/material.dart';
import 'package:qr_scanner/src/widgets/circular_container.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    @required this.text,
    @required this.function,
    @required this.context,
    @required this.buttonColor,
    @required this.textColor,
    this.elevation = 2.0,
    this.boderSideWidth = 0.0,
    this.boderSideColor = Colors.transparent,
    this.fontSize = 20.0,
    this.width = 500.0,
    this.height = 50.0,
    this.circularRadius = 10.0,
  });

  final String text;
  final VoidCallback function;
  final BuildContext context;
  final Color buttonColor;
  final Color textColor;
  final double elevation;
  final double boderSideWidth;
  final Color boderSideColor;
  final double fontSize;
  final double width;
  final double height;
  final double circularRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CircularContainer(
            circularRadius: this.circularRadius,
            height: this.height,
            width: this.width,
            child: RaisedButton(
              elevation: this.elevation,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: this.boderSideWidth, color: this.boderSideColor),
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              color: this.buttonColor,
              onPressed: function,
              child: Text(
                text,
                style: TextStyle(
                  color: this.textColor,
                  fontSize: this.fontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
