import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/Pages/user_list.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        String token = await _firebaseMessaging.getToken();
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  content: ListTile(
                      title: Text(message['notification']['title']),
                      subtitle: Text(message['notification']['body'])),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ));
      },
      onLaunch: (Map<String, dynamic> message) async {
      },
      onResume: (Map<String, dynamic> message) async {},
    );
  }


    @override
    Widget build(BuildContext context) {
      void _showSettingsPanel() {
        Navigator.pop(context);
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                child: SettingsForm(),
              );
            });
      }

      return StreamProvider<List<UserData>>.value(
        value: DataBaseService().users,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            title: Text('Meet In The Middle'),
            backgroundColor: Colors.grey[850],
            actions: <Widget>[
              FlatButton.icon(
                textColor: Colors.white,
                icon: Icon(Icons.person),
                label: Text('Logout'),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ],
          ),
          drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                    ),
                    child: Text(
                      'Meet In The Middle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Update Profile'),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      _showSettingsPanel();
                    },
                  ),
                  ListTile(
                    title: Text('Update Location'),
                    leading: Icon(Icons.location_on),
                    onTap: () {},
                  ),
                ],
              )),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UserList(),
            ],
          ),
        ),
      );
    }
  }
