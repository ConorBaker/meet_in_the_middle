import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';

class UserTile extends StatelessWidget {
  final UserData user;

  UserTile({this.user});

  FirebaseAuth _auth;
  String userid;
  String not = "";

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
                          content: Text('Are you sure you want to request ' + user.name + 's Location?' ),
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
                                final FirebaseUser cUser = await _auth.currentUser();
                                userid = cUser.uid;
                                await DataBaseService(uid: user.uid).updateUserData(
                                    user.uid,
                                    user.name,
                                    user.lat,
                                    user.lng,
                                    user.token,
                                    "request_" + userid,user.profileImage);
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
            },
            title: Text(user.name,style: TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.w500,
            )),
          ),
        ));
  }
}
