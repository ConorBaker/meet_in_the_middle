import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:location/location.dart';
import 'package:meet_in_the_middle/Pages/users.tile.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/CountDownTimer.dart';
import 'package:meet_in_the_middle/shared/loading.dart';
import 'package:provider/provider.dart';

//import 'package:sms/sms.dart';
import 'Graph.dart';
import 'map.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  FirebaseAuth _auth;
  String userid;

  @override
  void initState() {
    super.initState();
    _collapse();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  check(BuildContext context, List users) async {
    _collapse();
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
  List<String> recipents = [];
  int _key;

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
            return ExpansionTile(
              key: new Key(_key.toString()),
              title: UserTile(users[index]),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        child: Text("Request Location"),
                        onPressed: () {
                          showGeneralDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionBuilder:
                                  (context, a1, a2, widget) {
                                final curvedValue = Curves.easeInOutBack
                                    .transform(a1.value) -
                                    1.0;
                                return Transform(
                                  transform: Matrix4.translationValues(
                                      0.0, curvedValue * 200, 0.0),
                                  child: Opacity(
                                    opacity: a1.value,
                                    child: AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              16.0)),
                                      title: Text(
                                          'You are about to request a location!'),
                                      content: Text(
                                          'Are you sure you want to request ' +
                                              users[index].name +
                                              's Location?'),
                                      actions: [
                                        FlatButton(
                                            child: Text("No"),
                                            onPressed: () {
                                              Navigator.of(buildContext)
                                                  .pop();
                                            }),
                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            Navigator.of(buildContext)
                                                .pop();
                                            _auth = FirebaseAuth.instance;
                                            final FirebaseUser cUser =
                                            await _auth.currentUser();
                                            userid = cUser.uid;
                                            recipents = [];
                                            recipents.add(users[index].number);
                                            String message = users[index].name +
                                                ", I have requested your location. Please visit your Meet in the Middle app to either confirm or deny my request.";
                                            _sendSMS(message, recipents);
                                            await DataBaseService(
                                                uid: users[index].uid)
                                                .updateUserData(
                                                users[index].uid,
                                                users[index].name,
                                                users[index].lat,
                                                users[index].lng,
                                                users[index].token,
                                                "request_" + userid,
                                                users[index].profileImage,
                                                0,
                                                users[index].parent,
                                                users[index].number);

                                            Navigator.push(
                                              buildContext,
                                              MaterialPageRoute(
                                                  builder:
                                                      (buildContext) =>
                                                      CountDownTimer(
                                                          users[index])),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              transitionDuration:
                              Duration(milliseconds: 200),
                              barrierDismissible: true,
                              barrierLabel: '',
                              context: buildContext,
                              pageBuilder: (buildContext, animation1,
                                  animation2) {});
                        }),
                    FlatButton(
                      child: Text("View Location Graph"),
                      onPressed: () async {
                        _populateGraph(buildContext,users[index]);
                        Navigator.push(
                            buildContext,
                            MaterialPageRoute(
                              builder:
                                  (buildContext) =>
                                  Loading(),
                            ));
                        setState(() {
                          _collapse();
                        });
                      },
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while(newKey == _key);
  }

  showNotification(String message) async {
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin
        .show(0, 'Meet In The Middle', message, platform, payload: '');
  }


  void _populateGraph(BuildContext buildContext,UserData user) async {
    var data = await fetchData(user);
    var keys = data.keys.toList();
    var values = data.values.toList();
    if (data !=null ){
      Navigator.of(buildContext).pop();
      Navigator.push(
        buildContext,
        MaterialPageRoute(
            builder:
                (buildContext) =>
                Graph(
                    user,keys,values)),
      );
    }
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Future<Map<String, int>> fetchData(UserData user) async {
    var amount = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection("locations")
        .getDocuments();

    int placeAmount = amount.documents.length + 1;
    int lastWeek = 1;
//last 5 days
    if (placeAmount > 360) {
      lastWeek = (placeAmount - 479);
    }
    var listForGraph = Map();
    for (lastWeek; lastWeek < placeAmount - 1; lastWeek++) {
      var l = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection("locations")
          .document(lastWeek.toString())
          .get();

      Map<dynamic, dynamic> map = l.data;
      List list = map.values.toList();
      String dateCheck1 = list[0];
      var dateCheck2 = dateCheck1.split("/");
      String placeName = dateCheck2[0];

      if (!listForGraph.containsKey(placeName)) {
        listForGraph[placeName] = 1;
      } else {
        listForGraph[placeName] += 1;
      }
    }

    var mapEntries = listForGraph.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    listForGraph
      ..clear()
      ..addEntries(mapEntries);

    List values = listForGraph.values.toList();
    List keys = listForGraph.keys.toList();

    Map<String, int> rData = {keys[keys.length-1]: values[values.length-1], keys[keys.length-2]: values[values.length-2], keys[keys.length-3]: values[values.length-3], keys[keys.length-4]: values[values.length-4]};

    return rData;
  }
}
