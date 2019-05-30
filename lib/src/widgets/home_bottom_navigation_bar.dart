import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          title: Text("Add"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delete),
          title: Text("Delete"),
        ),
      ],
    );
  }
}
