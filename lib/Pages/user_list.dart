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

  check(BuildContext context, List users) async {
    _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    userid = user.uid;
    for (var user in users) {
      String compare = user.message;
      var spl = compare.split("_");
      if (spl[0] == "request" && userid == user.uid) {
        await DataBaseService(uid: user.uid).updateUserData(
            user.uid, user.name, user.lat, user.lng, user.token, "",user.profileImage);
        showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue = Curves.easeInOutBack.transform(a1.value) -
                  1.0;
              return Transform(
                transform: Matrix4.translationValues(
                    0.0, curvedValue * 200, 0.0),
                child: Opacity(
                  opacity: a1.value,
                  child: AlertDialog(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    title: Text('Your location has been Requested!'),
                    content: Text('Someone has requested your location'),
                    actions: [
                      FlatButton(
                        child: Text("Deny"),
                        onPressed: () {
                              Navigator.of(context).pop();
                            }
                      ),
                      FlatButton(
                        child: Text("Accept"),
                        onPressed: () async {
                          for (var user2 in users) {
                            if (user2.uid == spl[1]) {
                              await DataBaseService(uid: user2.uid)
                                  .updateUserData(
                                  user2.uid, user2.name, user2.lat, user2.lng,
                                  user2.token,
                                  "sent_" + user.lat.toString() + "_" +
                                      user.lng.toString(),user.profileImage);
                              Navigator.of(context).pop();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation1, animation2) {});
      } else if (spl[0] == "sent" && user.uid == userid) {
        await DataBaseService(uid: user.uid).updateUserData(
            user.uid, user.name, user.lat, user.lng, user.token, "",user.profileImage);
        OpenMap(spl[1], spl[2]);
      }
    }
  }

  void OpenMap(String lat, String lng) {
    var dlat = double.parse(lat);
    var dlng = double.parse(lng);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen(dlat, dlng)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context) ?? [];
    check(context, users);
    return
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            if (users[index].uid != userid) {
                  return UserTile(user: users[index]);
            } else {
              return Container();
            }
          }
      );
  }
}

