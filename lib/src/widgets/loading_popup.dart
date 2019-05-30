import 'package:flutter/material.dart';
import 'package:qr_scanner/src/helpers/error_case.dart';
import 'package:qr_scanner/src/widgets/color_loader_popup.dart';

class LoadingPopup extends StatefulWidget {
  LoadingPopup({this.future, this.successFunction, this.failFunction});

  final future;
  final successFunction;
  final failFunction;

  _LoadingPopupState createState() => _LoadingPopupState();
}

class _LoadingPopupState extends State<LoadingPopup> {
  bool _canCall;

  void initState() {
    _canCall = true;
    _executeFuture();
    super.initState();
  }

  _executeFuture() async {
    if (_canCall) {
      setState(() {
        _canCall = false;
      });

      try {
        var result = await widget.future();
        if (widget.successFunction != null) widget.successFunction();

        Future.delayed(
          Duration(microseconds: 1),
        ).then((_) => Navigator.pop(context, result));
      } catch (error) {
        Navigator.pop(context);
        errorCase(error.toString(), context, () => widget.failFunction);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ColorLoaderPopup(),
    );
  }
}
