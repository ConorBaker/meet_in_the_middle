import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/Pages/place_list.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/approve_locations.dart';
import 'package:meet_in_the_middle/shared/category_selector.dart';
import 'package:meet_in_the_middle/shared/currernt_login.dart';
import 'package:meet_in_the_middle/shared/family_maker.dart';
import 'package:meet_in_the_middle/shared/join_family.dart';
import 'package:provider/provider.dart';

class bad_places extends StatefulWidget {
  @override
  _bad_placesState createState() => _bad_placesState();
}

class _bad_placesState extends State<bad_places> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
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
      var placesCheck =
      await Firestore.instance.collection('places').getDocuments();
      int l = placesCheck.documents.length + 1;
      for (int i = 1; i < l; i++) {
        DocumentSnapshot variable = await Firestore.instance.collection('places').document(i.toString()).get();
        if (variable.data['picture'] == " ") {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: approval(id: i.toString(),address : variable.data['name']),
                  ),
                );
              });
        }
      }
    }

    return StreamProvider<List<Place>>.value(
      value: DataBaseService().places,
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
                  onTap: () {
                    _approveLocations();
                  },
                )
              ],
            )),
        body: Column(
          children: <Widget>[
            CategorySelector(2),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 243, 245, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: PlaceList("bad")
              ),
            ),
          ],
        ),
      ),
    );
  }
}

