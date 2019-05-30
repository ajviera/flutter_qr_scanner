import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/src/providers/theme_change_notifier.dart';
import 'package:qr_scanner/src/screens/qr_scan/create_qr_page.dart';
import 'package:qr_scanner/src/screens/qr_scan/scan_qr_page.dart';
import 'package:qr_scanner/src/widgets/dot_indicator.dart';

class QrScanPage extends StatefulWidget {
  final Function showSnackBar;
  QrScanPage({
    Key key,
    @required this.showSnackBar,
  }) : super(key: key);

  @override
  QrScanPageState createState() => QrScanPageState();
}

class QrScanPageState extends State<QrScanPage> {
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      ScanQRPage(showSnackBar: widget.showSnackBar),
      CreateQRPage(showSnackBar: widget.showSnackBar),
    ];
    return Stack(
      children: <Widget>[
        BackgroundDesign(),
        PageView(
          controller: _controller,
          onPageChanged: (int index) => {},
          children: _pages,
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: DotsIndicator(
                context: context,
                controller: _controller,
                itemCount: _pages.length,
                onPageSelected: (int page) {
                  _controller.animateToPage(
                    page,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundDesign extends StatelessWidget {
  final Widget child;
  const BackgroundDesign({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Provider.of<ThemeChangeNotifier>(context)
          .getTheme()
          .appBarBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                color: Provider.of<ThemeChangeNotifier>(context)
                    .getTheme()
                    .backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(110),
                  topRight: Radius.circular(110),
                ),
              ),
              child: this.child != null
                  ? this.child
                  : Container(color: Colors.transparent),
            ),
          ),
          Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
