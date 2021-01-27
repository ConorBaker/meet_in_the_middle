import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/map.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';



class UserTile extends StatelessWidget {
  final UserData user;
  UserTile({this.user});
  FirebaseAuth _auth;
  String userid;

  @override
  Widget build(BuildContext context) {
      return Padding(
          padding: EdgeInsets.only(top: 10),
          child: Card(
            margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[900],
                backgroundImage: AssetImage('assets/LogoNoBlack.jpg'),
              ),
              onTap: () async{
                _auth = FirebaseAuth.instance;
                final FirebaseUser cUser = await _auth.currentUser();
                userid = cUser.uid;
                await DataBaseService(uid: user.uid).updateUserData(
                    user.uid, user.name, user.lat, user.lng, user.token,"request-"+userid);
                final snackBar = SnackBar(
                    content: Text("Request Sent")
                );
                Scaffold.of(context).showSnackBar(snackBar);
              },
              title: Text(user.name),
            ),
          )
      );
    }

}