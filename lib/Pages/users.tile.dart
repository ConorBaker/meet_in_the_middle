import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/users.dart';
//import 'package:sms/sms.dart';

class UserTile extends StatelessWidget {
  final UserData user;

  UserTile(this.user);

  FirebaseAuth _auth;
  String userid;
  String not = "";

  List<String> recipents = [];

  @override
  Widget build(BuildContext buildContext) {
    return Padding(
      padding: EdgeInsets.only(top: 0.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: EdgeInsets.fromLTRB(5, 16, 0, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[900],
            backgroundImage: AssetImage(user.profileImage),
          ),
          title: Text(user.name,
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
    );
  }
}
