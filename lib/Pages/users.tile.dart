import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/CountDownTimer.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:meet_in_the_middle/shared/loading.dart';

import 'Graph.dart';
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
        margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[900],
            backgroundImage: AssetImage(user.profileImage),
          ),
          onTap: () async {
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
                        title: Text("What would you like to do?"),
                        actions: [
                          FlatButton(
                              child: Text("Request Location"),
                              onPressed: () {
                                Navigator.of(buildContext).pop();
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
                                                    user.name +
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
                                                  recipents.add(user.number);
                                                  String message = user.name +
                                                      ", I have requested your location. Please visit your Meet in the Middle app to either confirm or deny my request.";
                                                  _sendSMS(message, recipents);
                                                  await DataBaseService(
                                                          uid: user.uid)
                                                      .updateUserData(
                                                          user.uid,
                                                          user.name,
                                                          user.lat,
                                                          user.lng,
                                                          user.token,
                                                          "request_" + userid,
                                                          user.profileImage,
                                                          0,
                                                          user.parent,
                                                          user.number);

                                                  Navigator.push(
                                                    buildContext,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (buildContext) =>
                                                                CountDownTimer(
                                                                    user)),
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
                              Navigator.of(buildContext).pop();
                              _populateGraph(buildContext);
                              Navigator.push(
                                  buildContext,
                                  MaterialPageRoute(
                                    builder:
                                        (buildContext) =>
                                        Loading(),
                                  ));
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
                context: buildContext,
                pageBuilder: (buildContext, animation1, animation2) {});
          },
          title: Text(user.name,
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w500,
              )),
          trailing: Icon(Icons.more_vert),
        ),
      ),
    );
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }


  void _populateGraph(BuildContext buildContext) async {
    var data = await fetchData();
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

  Future<Map<String, int>> fetchData() async {
    var amount = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection("locations")
        .getDocuments();

    int placeAmount = amount.documents.length + 1;
    int lastWeek = 1;
//last 5 days
    if (placeAmount > 479) {
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
