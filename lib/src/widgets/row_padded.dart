import 'package:flutter/material.dart';

class RowPadded extends StatelessWidget {
  const RowPadded({
    Key key,
    @required this.primaryText,
    @required this.secondaryText,
  }) : super(key: key);

  final String primaryText;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x80000000)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    primaryText,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Text(
            secondaryText,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
