import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/Pages/users.tile.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';

import 'map.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
   FirebaseAuth _auth;
   FirebaseUser user;
   String userid;

  check (BuildContext context,List users) async {
    _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    userid = user.uid;
    for (var user in users) {
      String compare = user.message;
      var spl = compare.split("-");
      if (spl[0] == "request" && userid == user.uid) {
        await DataBaseService(uid: user.uid).updateUserData(
            user.uid, user.name, user.lat, user.lng, user.token,"");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text("Location Requested"),
            ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () async {
                      for (var user in users) {
                        if(user.uid == spl[1]){
                          await DataBaseService(uid: user.uid).updateUserData(
                              user.uid, user.name, user.lat, user.lng, user.token,
                              "sent-" + user.uid);
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  )
              ]
        )
        );
      }else if (spl[0] == "sent" && user.uid == userid) {
        await DataBaseService(uid: user.uid).updateUserData(
            user.uid, user.name, user.lat, user.lng, user.token,"");
            OpenMap(user);
      }
    }
  }

  void OpenMap(UserData user){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen(user.lat,user.lng)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context) ?? [];
    check(context,users);
      return
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              if(users[index].uid != userid){
                return UserTile(user: users[index] );
              }else{
                return Container();
              }
            }
        );
    }
  }
