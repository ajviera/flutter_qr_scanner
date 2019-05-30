import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCircleAvatar extends StatelessWidget {
  const UserCircleAvatar({
    Key key,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 40.0,
      backgroundImage: imageUser(),
    );
  }

  imageUser() {
    if (user.photoUrl != null) {
      return NetworkImage(user.photoUrl);
    } else {
      return AssetImage('assets/images/iron-man-silhouette.png');
    }
  }
}
