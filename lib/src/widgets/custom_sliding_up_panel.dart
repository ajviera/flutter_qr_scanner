import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomSlidingUpPanel extends StatefulWidget {
  final PanelController panelController;
  final panelFunction;
  final sliderContent;
  const CustomSlidingUpPanel({
    @required this.panelController,
    @required this.panelFunction,
    @required this.sliderContent,
  });

  @override
  _CustomSlidingUpPanelState createState() => _CustomSlidingUpPanelState();
}

class _CustomSlidingUpPanelState extends State<CustomSlidingUpPanel> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      minHeight: 0.1,
      maxHeight: 375.0,
      controller: widget.panelController,
      // backdropEnabled: true,
      panel: _sliderPanel(),
      onPanelSlide: (double pos) => widget.panelFunction(pos),
    );
  }

  Widget _sliderPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40.0),
              Container(
                width: 140,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF9fa5b4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
          widget.sliderContent,
        ],
      ),
    );
  }
}
