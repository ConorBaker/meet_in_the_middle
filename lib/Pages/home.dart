import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/Pages/user_list.dart';
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
import 'package:workmanager/workmanager.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}

Future execute(var inputData) async {
  Position userLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  var _list = inputData.values.toList();
  DocumentSnapshot variable =
      await Firestore.instance.collection('users').document(_list[0]).get();
  String lat2 = variable.data['lat'].toStringAsFixed(3);
  String lng2 = variable.data['lng'].toStringAsFixed(3);
  String lat1 = userLocation.latitude.toStringAsFixed(3);
  String lng1 = userLocation.longitude.toStringAsFixed(3);
  List<Placemark> placemark = await Geolocator()
      .placemarkFromCoordinates(userLocation.latitude, userLocation.longitude);

  var placesCheck =
      await Firestore.instance.collection('places').getDocuments();
  int l = placesCheck.documents.length + 1;
  bool found = false;
  for (int i = 1; i < l; i++) {
    DocumentSnapshot variable2 = await Firestore.instance
        .collection('places')
        .document(i.toString())
        .get();
    String name = variable2.data['name'];
    if (name ==
            placemark[0].name +
                " " +
                placemark[0].thoroughfare +
                " " +
                placemark[0].administrativeArea ||
        lat1 == variable2.data['lat'].toStringAsFixed(3) &&
            lng1 == variable2.data['lng'].toStringAsFixed(3)) {
      found = true;
    }
  }

  var amount = await Firestore.instance
      .collection('users')
      .document(_list[0])
      .collection("locations")
      .getDocuments();

  int placeAmount = amount.documents.length + 1;
  int lastWeek = 0;
  //last 5 days
  if (placeAmount > 479) {
    lastWeek = (placeAmount - 479);
  }

  await Firestore.instance
      .collection('users')
      .document(_list[0])
      .collection("locations")
      .document(placeAmount.toString())
      .setData({
    "data": placemark[0].name +
        "_" +
        placemark[0].thoroughfare +
        "_" +
        placemark[0].administrativeArea +
        "/" +
        userLocation.latitude.toString() +
        "/" +
        userLocation.longitude.toString() +
        "/" +
        DateTime.now().toString()
  });

  bool found2 = false;
  for (lastWeek; lastWeek < placeAmount - 1; lastWeek++) {
    var l = await Firestore.instance
        .collection('users')
        .document(_list[0])
        .collection("locations")
        .document(lastWeek.toString())
        .get();

    String dateCheck1 = l.data['data'];
    var dateCheck2 = dateCheck1.split("/");
    var dateCheck = dateCheck2[dateCheck2.length].split(" ");
    String lat1 = userLocation.latitude.toStringAsFixed(3);
    String lng1 = userLocation.longitude.toStringAsFixed(3);
    String lat2 =
        double.parse(dateCheck2[dateCheck2.length - 2]).toStringAsFixed(3);
    String lng2 =
        double.parse(dateCheck2[dateCheck2.length - 1]).toStringAsFixed(3);

    String todayDate = DateTime.now().toString();
    var tdCheck = todayDate.split(" ");

    if (dateCheck[0] != tdCheck[0]) {
      if (lat1 == lat2 && lng1 == lng2) {
        found2 = true;
      }
    }
  }

  if (lat1 == lat2 && lng1 == lng2 && found == false) {
    int x = variable.data['count'];
    if (x == 2) {
      x = x + 1;
      if (found2) {
        var places =
            await Firestore.instance.collection('places').getDocuments();
        String newID = (places.documents.length + 1).toString();
        DateTime now = new DateTime.now();
        await DataBaseService(uid: newID).updatePlaceData(
            placemark[0].name +
                " " +
                placemark[0].thoroughfare +
                " " +
                placemark[0].administrativeArea,
            userLocation.latitude,
            userLocation.longitude,
            now.toString(),
            " ");
      }
      await DataBaseService(uid: _list[0]).updateUserData(
          variable.data['uId'],
          variable.data['name'],
          userLocation.latitude,
          userLocation.longitude,
          variable.data['token'],
          "",
          variable.data['profileImage'],
          x,
          variable.data['parent']);
    } else if (x > 2) {
    } else if (x < 2) {
      x = x + 1;
      await DataBaseService(uid: _list[0]).updateUserData(
          variable.data['uId'],
          variable.data['name'],
          userLocation.latitude,
          userLocation.longitude,
          variable.data['token'],
          "",
          variable.data['profileImage'],
          x,
          variable.data['parent']);
    }
  } else if (found == true) {
    await DataBaseService(uid: _list[0]).updateUserData(
        variable.data['uId'],
        variable.data['name'],
        userLocation.latitude,
        userLocation.longitude,
        variable.data['token'],
        "",
        variable.data['profileImage'],
        3,
        variable.data['parent']);
  } else {
    await DataBaseService(uid: _list[0]).updateUserData(
        variable.data['uId'],
        variable.data['name'],
        userLocation.latitude,
        userLocation.longitude,
        variable.data['token'],
        "",
        variable.data['profileImage'],
        0,
        variable.data['parent']);
  }
}

const fetchBackground = "fetchBackground";

void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        await execute(inputData);
        break;
    }
    return Future.value(true);
  });
}

class Home_State extends State<Home> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;

  void main(String uid) {
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Geolocator().checkGeolocationPermissionStatus();
    Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
    Workmanager.registerPeriodicTask("1", fetchBackground,
        inputData: {'string': uid}, initialDelay: Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    main(user.uid);
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
                        id: i.toString(), address: variable.data['name']),
                  ),
                );
              });
        }
      }
    }

    void permissionDenied(BuildContext context) {
      Flushbar(
        message: 'You do not have permission to that! You will have to ask your parent',
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
            /*
            ListTile(
              title: Text('Reset Background Location'),
              leading: Icon(Icons.reset_tv),
              onTap: () {


                final user = Provider.of<User>(context);
                Workmanager.cancelByTag("1");
                Workmanager.initialize(callbackDispatcher,
                    isInDebugMode: false);
                Workmanager.registerPeriodicTask("1", fetchBackground,
                    //frequency: Duration(minutes: 16),
                    inputData: {'string': user.uid},
                    initialDelay: Duration(seconds: 5));

              },
            )

             */
          ],
        )),
        body: Column(
          children: <Widget>[
            CategorySelector(0),
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
