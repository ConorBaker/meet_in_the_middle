import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
//import 'package:telephony/telephony.dart';
import 'map.dart';

class UserTile extends StatelessWidget {
  final UserData user;

  UserTile({this.user});

  FirebaseAuth _auth;
  String userid;
  String not = "";

  List<String> recipents = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  @override
  Widget build(BuildContext context) {
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
                      transform: Matrix4.translationValues(
                          0.0, curvedValue * 200, 0.0),
                      child: Opacity(
                        opacity: a1.value,
                        child: AlertDialog(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          title: Text('You are about to request a location!'),
                          content: Text('Are you sure you want to request ' +
                              user.name +
                              's Location?'),
                          actions: [
                            FlatButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                _auth = FirebaseAuth.instance;
                                final FirebaseUser cUser =
                                    await _auth.currentUser();
                                userid = cUser.uid;
                                recipents = [];
                                recipents.add(user.number);
                                _sendSMS(user.name +
                                    ", I have requested your location. Please visit your Meet in the Middle app to either confirm or deny my request.", recipents);
                                /*
                                final Telephony telephony = await Telephony.instance;
                                telephony.sendSms(
                                    to: user.number,
                                    message: user.name +
                                        ", I have requested your location. Please visit your Meet in the Middle app to either confirm or deny my request.");

                                 */
                                await DataBaseService(uid: user.uid)
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
              Future.delayed(Duration(minutes: 15), () async {
                DocumentSnapshot variable = await Firestore.instance
                    .collection('users')
                    .document(user.uid)
                    .get();
                var spl = variable.data['message'].split("_");
                if (spl[0] == "waiting" || spl[0] == "request") {
                  var dlat = double.parse(user.lat.toString());
                  var dlng = double.parse(user.lng.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapScreen(dlat, dlng)),
                  );
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
                  showNotification();
                }
              });
            },
            title: Text(user.name,
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ));
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  showNotification() async {
    var android = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Meet In The Middle',
        'Location request is now available to view',
        platform,
        payload: '');
  }
}
