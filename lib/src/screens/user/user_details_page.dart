import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/src/widgets/row_padded.dart';
import 'package:qr_scanner/src/widgets/user_circle_avatar.dart';

class UserDetailsPage extends StatefulWidget {
  UserDetailsPage({this.user});

  final FirebaseUser user;

  @override
  UserDetailsPageState createState() => UserDetailsPageState();
}

class UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 140.0),
          child: Column(
            children: [
              Container(
                child: UserCircleAvatar(user: widget.user),
                margin: const EdgeInsets.only(bottom: 30.0),
              ),
              RowPadded(
                primaryText: 'Email:',
                secondaryText: widget.user.email,
              ),
              RowPadded(
                primaryText: 'Name:',
                secondaryText: widget.user.displayName != null
                    ? widget.user.displayName
                    : '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
