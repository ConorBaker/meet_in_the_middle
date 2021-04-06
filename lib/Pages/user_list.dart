import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:meet_in_the_middle/Pages/users.tile.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';
//import 'package:sms/sms.dart';
import 'map.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  FirebaseAuth _auth;
  String userid;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  check(BuildContext context, List users) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    userid = user.uid;
    for (var user in users) {
      String compare = user.message;
      var spl = compare.split("_");
      if (spl[0] == "request" && userid == user.uid) {
        await DataBaseService(uid: user.uid).updateUserData(
            user.uid,
            user.name,
            user.lat,
            user.lng,
            user.token,
            "waiting",
            user.profileImage,
            0,
            user.parent,
            user.number);
        showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue =
                  Curves.easeInOutBack.transform(a1.value) - 1.0;
              return Transform(
                transform:
                    Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
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
                          onPressed: () async {
                            DocumentSnapshot variable = await Firestore.instance
                                .collection('users')
                                .document(userid)
                                .get();
                            await DataBaseService(uid: userid).updateUserData(
                              variable.data['uId'],
                              variable.data['name'],
                              variable.data['lat'],
                              variable.data['lng'],
                              variable.data['token'],
                              "",
                              variable.data['profileImage'],
                              variable.data['count'],
                              variable.data['parent'],
                              variable.data['number'],
                            );

                            DocumentSnapshot variable2 = await Firestore
                                .instance
                                .collection('users')
                                .document(spl[1])
                                .get();
                            await DataBaseService(uid: spl[1]).updateUserData(
                              variable2.data['uId'],
                              variable2.data['name'],
                              variable2.data['lat'],
                              variable2.data['lng'],
                              variable2.data['token'],
                              "no_" + "0" + "_" + "0",
                              variable2.data['profileImage'],
                              variable2.data['count'],
                              variable2.data['parent'],
                              variable2.data['number'],
                            );
                            Navigator.of(context).pop();
                          }),
                      FlatButton(
                        child: Text("Accept"),
                        onPressed: () async {
                          DocumentSnapshot variable = await Firestore.instance
                              .collection('users')
                              .document(spl[1])
                              .get();
                          _serviceEnabled = await location.serviceEnabled();
                          _locationData = await location.getLocation();
                          await DataBaseService(uid: spl[1]).updateUserData(
                            variable.data['uId'],
                            variable.data['name'],
                            variable.data['lat'],
                            variable.data['lng'],
                            variable.data['token'],
                            "sent_" +
                                user.lat.toString() +
                                "_" +
                                user.lng.toString(),
                            variable.data['profileImage'],
                            variable.data['count'],
                            variable.data['parent'],
                            variable.data['number'],
                          );

                          DocumentSnapshot variable2 = await Firestore.instance
                              .collection('users')
                              .document(userid)
                              .get();
                          await DataBaseService(uid: userid).updateUserData(
                            variable2.data['uId'],
                            variable2.data['name'],
                            variable2.data['lat'],
                            variable2.data['lng'],
                            variable2.data['token'],
                            "",
                            variable2.data['profileImage'],
                            variable2.data['count'],
                            variable2.data['parent'],
                            variable2.data['number'],
                          );
                          Navigator.of(context).pop();
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
            user.uid,
            user.name,
            user.lat,
            user.lng,
            user.token,
            "",
            user.profileImage,
            0,
            user.parent,
            user.number);
        showNotification(
            "Location request has been approved and is ready to view");
        Navigator.of(context).pop();
        OpenMap(spl[1], spl[2]);
      } else if (spl[0] == "no" && user.uid == userid) {
        await DataBaseService(uid: user.uid).updateUserData(
            user.uid,
            user.name,
            user.lat,
            user.lng,
            user.token,
            "",
            user.profileImage,
            0,
            user.parent,
            user.number);
        showNotification("Location request has been denied");
        Navigator.of(context).pop();
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

  int count = 0;

  @override
  Widget build(BuildContext buildContext) {
    final users = Provider.of<List<UserData>>(buildContext) ?? [];
    check(buildContext, users);
    UserData user;
    for (var u in users) {
      if (userid == u.uid) {
        user = u;
      }
    }
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          if (users[index].uid != userid &&
              users[index].token == user.token &&
              users[index].token != "") {
            return UserTile(users[index]);
          } else {
            return Container();
          }
        });
  }

  showNotification(String message) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin
        .show(0, 'Meet In The Middle', message, platform, payload: '');
  }
}
