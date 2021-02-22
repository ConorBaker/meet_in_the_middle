import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meet_in_the_middle/Pages/users.tile.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';

class CurrentLogin extends StatefulWidget {
  @override
  _CurrentLoginState createState() => _CurrentLoginState();
}

class _CurrentLoginState extends State<CurrentLogin> {
  Future<UserData> getData() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user1 = await _auth.currentUser();
    final DocumentSnapshot data =
        await Firestore.instance.collection('users').document(user1.uid).get();
    UserData user = DataBaseService(uid: user1.uid).userDataFromSnapShot(data);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[900],
                backgroundImage: AssetImage(snapshot.data.profileImage),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(snapshot.data.name == 'New Family Member' ?  ' ' : snapshot.data.name, style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500)),
                Text("Family Code: " + snapshot.data.token)
              ],
            )
          ]);
        } else {
          return Container();
        }
      },
    );
  }
}
