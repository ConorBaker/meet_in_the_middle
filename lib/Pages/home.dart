import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/Pages/user_list.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/services/local_notification.dart';
import 'package:meet_in_the_middle/shared/category_selector.dart';
import 'package:meet_in_the_middle/shared/currernt_login.dart';
import 'package:meet_in_the_middle/shared/family_maker.dart';
import 'package:meet_in_the_middle/shared/join_family.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}
const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  Workmanager.executeTask((getLocation, inputData) async {
    switch (getLocation) {
      case fetchBackground:
        WidgetsFlutterBinding.ensureInitialized();
        GeolocationStatus geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
        Position userLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        break;
    }
    return Future.value(true);
  });
}


class Home_State extends State<Home> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;

  void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await Workmanager.initialize(callbackDispatcher,isInDebugMode: true);
    Workmanager.registerPeriodicTask("1", fetchBackground,
        frequency: Duration(minutes: 15),
        initialDelay: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    main();
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
          ],
        )),
        body: Column(
          children: <Widget>[
            CategorySelector(),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 243, 245, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: UserList()),
            ),
          ],
        ),
      ),
    );
  }
}
