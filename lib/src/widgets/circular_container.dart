import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  CircularContainer({
    @required this.child,
    this.width = 500.0,
    this.height = 50.0,
    this.circularRadius = 10.0,
  });
  final Widget child;
  final double width;
  final double height;
  final double circularRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(this.circularRadius)),
        color: Colors.white,
      ),
      height: this.height,
      width: this.width,
      child: child,
    );
  }
}
