import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/Pages/user_list.dart';
import 'package:meet_in_the_middle/Pages/view_bad_place.dart';
import 'package:meet_in_the_middle/Pages/view_safe_places.dart';
import 'package:meet_in_the_middle/Pages/view_users.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/approve_locations.dart';
import 'package:meet_in_the_middle/shared/category_selector.dart';
import 'package:meet_in_the_middle/shared/currernt_login.dart';
import 'package:meet_in_the_middle/shared/family_maker.dart';
import 'package:meet_in_the_middle/shared/join_family.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;

  PageController controller = PageController();
  var currentPageValue = 0.0;

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });

    final user = Provider.of<User>(context);
    void _showSettingsPanel() {
      Navigator.pop(context);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: SettingsForm(),
              ),
            );
          });
    }

    void _createFamily() {
      Navigator.pop(context);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(child: CreateFamily()),
            );
          });
    }

    void _joinFamily() {
      Navigator.pop(context);
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: JoinFamily(),
              ),
            );
          });
    }

    Future<void> _approveLocations() async {
      Navigator.pop(context);
      DocumentSnapshot variable2 = await Firestore.instance.collection('users').document(user.uid).get();
      var placesCheck =
          await Firestore.instance.collection('places').getDocuments();
      int l = placesCheck.documents.length + 1;
      for (int i = 1; i < l; i++) {
        DocumentSnapshot variable = await Firestore.instance
            .collection('places')
            .document(i.toString())
            .get();
        if (variable.data['picture'] == " ") {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: approval(
                        id: i.toString(), address: variable.data['name'],token : variable2.data['token']),
                  ),
                );
              });
        }
      }
    }

    void permissionDenied(BuildContext context) {
      Flushbar(
        message:
            'You do not have permission to that! You will have to ask your parent',
        duration: Duration(seconds: 5),
      )..show(context);
    }

    return StreamProvider<List<UserData>>.value(
      value: DataBaseService().users,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(163, 217, 229, 1),
        appBar: AppBar(
          title: Text('Meet In The Middle',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Color.fromRGBO(163, 217, 229, 1),
          elevation: 0.0,
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
                color: Color.fromRGBO(163, 217, 229, 1),
              ),
              child: Row(children: [
                //,
                CurrentLogin()
              ]),
            ),
            ListTile(
              title: Text('Update Profile'),
              leading: Icon(Icons.settings),
              onTap: () {
                _showSettingsPanel();
              },
            ),
            ListTile(
              title: Text('Create a Family'),
              leading: Icon(Icons.add),
              onTap: () {
                _createFamily();
              },
            ),
            ListTile(
              title: Text('Join a Family'),
              leading: Icon(Icons.workspaces_filled),
              onTap: () {
                _joinFamily();
              },
            ),
            ListTile(
              title: Text('Approve Safe Locations'),
              leading: Icon(Icons.approval),
              onTap: () async {
                DocumentSnapshot variable = await Firestore.instance
                    .collection('users')
                    .document(user.uid)
                    .get();
                if (variable.data['parent'] == true) {
                  _approveLocations();
                } else {
                  Navigator.pop(context);
                  permissionDenied(context);
                }
              },
            ),
          ],
        )),
        body: Column(
          children: <Widget>[
            Expanded(
                child: PageView(
              children: <Widget>[
                users(),
                safe_places(user.uid),
                bad_places(user.uid),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
