import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/services/auth.dart';
import 'package:meet_in_the_middle/Pages/wrapper.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'models/user.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future execute(var inputData) async {
  Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  Position userLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser cUser = await _auth.currentUser();
  String currentUserId = cUser.uid;
  List<DocumentSnapshot> places = [];
  DocumentSnapshot variable = await Firestore.instance
      .collection('users')
      .document(currentUserId)
      .get();
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
    if(variable2.data['picture'] == 'assets/bad.png'){
      places.add(variable2);
    }
    if (name ==
            placemark[0].name +
                " " +
                placemark[0].thoroughfare +
                " " +
                placemark[0].administrativeArea ||
        lat1 == variable2.data['lat'].toStringAsFixed(3) &&
            lng1 == variable2.data['lng'].toStringAsFixed(3)) {
      found = true;
      bool attending = false;
      String allPeople = variable2.data['people'];
      String updatedPeople = allPeople;
      if (allPeople != "") {
        var people = allPeople.split("_");
        for (int x = 0; x < people.length; x++) {
          if (people[x] == variable.data['name']) {
            attending = true;
          }
        }
      }
      if (!attending && variable.data['token'] == variable2.data['token']) {
        updatedPeople = allPeople + variable.data['name'] + "_";
      }

      await DataBaseService(uid: i.toString()).updatePlaceData(
          variable2.data['name'],
          variable2.data['lat'],
          variable2.data['lng'],
          variable2.data['day'],
          variable2.data['picture'],
          updatedPeople,
          variable.data['token']);
    } else {
      String updatedPeople = "";
      String allPeople = variable2.data['people'];
      if (allPeople != "") {
        var people = allPeople.split("_");
        for (int x = 0; x < people.length; x++) {
          if (people[x] != variable.data['name'] && people[x] != "" ) {
            updatedPeople = updatedPeople + people[x] + "_";
          }
        }
      }
      await DataBaseService(uid: i.toString()).updatePlaceData(
          variable2.data['name'],
          variable2.data['lat'],
          variable2.data['lng'],
          variable2.data['day'],
          variable2.data['picture'],
          updatedPeople,
          variable.data['token']);
    }
  }

  if (variable.data['parent'] == true) {
    CollectionReference _documentRef = Firestore.instance.collection("users");
    _documentRef.getDocuments().then((ds) {
      if (ds != null) {
        for (int c = 0; c < places.length; c++) {
          ds.documents.forEach((value) {
            var place = places[c];
            String placeLat = place.data['lat'].toStringAsFixed(3);
            String placeLng = place.data['lng'].toStringAsFixed(3);
            String userLat = value.data['lat'].toStringAsFixed(3);
            String userLng = value.data['lng'].toStringAsFixed(3);

            if ((placeLat == userLat && placeLng == userLng)) {
              if (place.data['picture'] == 'assets/bad.png') {
                if(variable.data['name'] != value.data['name'] && value.data['token'] == variable.data['token']){
                  showNotification(value.data['name'] +
                      " is in " + place.data['name'],value.data['name'] + " is in a place they shouldn't be"
                  );
                }
              }
            }
          });
        }
      }
    });
  }

  var amount = await Firestore.instance
      .collection('users')
      .document(currentUserId)
      .collection("locations")
      .getDocuments();

  int placeAmount = amount.documents.length + 1;
  int lastWeek = 1;
  //last 5 days
  if (placeAmount > 479) {
    lastWeek = (placeAmount - 479);
  }

  await Firestore.instance
      .collection('users')
      .document(currentUserId)
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
        .document(currentUserId)
        .collection("locations")
        .document(lastWeek.toString())
        .get();

    if (l != null) {
      Map<dynamic, dynamic> map = l.data;
      List list = map.values.toList();
      String dateCheck1 = list[0];
      var dateCheck2 = dateCheck1.split("/");
      String date = dateCheck2[dateCheck2.length - 1];
      var dateCheck = date.split(" ");
      String lat1 = userLocation.latitude.toStringAsFixed(3);
      String lng1 = userLocation.longitude.toStringAsFixed(3);
      String lat2 = double.parse(dateCheck2[1]).toStringAsFixed(3);
      String lng2 = double.parse(dateCheck2[2]).toStringAsFixed(3);

      String todayDate = DateTime.now().toString();
      var tdCheck = todayDate.split(" ");

      if (dateCheck[0] != tdCheck[0]) {
        if (lat1 == lat2 && lng1 == lng2) {
          found2 = true;
        }
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
            " ",
            "",
            variable.data['token']);
      }
      await DataBaseService(uid: currentUserId).updateUserData(
          variable.data['uId'],
          variable.data['name'],
          userLocation.latitude,
          userLocation.longitude,
          variable.data['token'],
          "",
          variable.data['profileImage'],
          x,
          variable.data['parent'],
          variable.data['number']);
    } else if (x > 2) {
    } else if (x < 2) {
      x = x + 1;
      await DataBaseService(uid: currentUserId).updateUserData(
          variable.data['uId'],
          variable.data['name'],
          userLocation.latitude,
          userLocation.longitude,
          variable.data['token'],
          "",
          variable.data['profileImage'],
          x,
          variable.data['parent'],
          variable.data['number']);
    }
  } else if (found == true) {
    await DataBaseService(uid: currentUserId).updateUserData(
        variable.data['uId'],
        variable.data['name'],
        userLocation.latitude,
        userLocation.longitude,
        variable.data['token'],
        "",
        variable.data['profileImage'],
        3,
        variable.data['parent'],
        variable.data['number']);
  } else {
    await DataBaseService(uid: currentUserId).updateUserData(
        variable.data['uId'],
        variable.data['name'],
        userLocation.latitude,
        userLocation.longitude,
        variable.data['token'],
        "",
        variable.data['profileImage'],
        0,
        variable.data['parent'],
        variable.data['number']);
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  Geolocator().checkGeolocationPermissionStatus();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager.registerPeriodicTask("1", fetchBackground,
      inputData: {},
      initialDelay: Duration(seconds: 30),
      frequency: Duration(minutes: 20));

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

showNotification(String message,title) async {
  var android = AndroidNotificationDetails('id', 'channel ', 'description',
      priority: Priority.High, importance: Importance.Max);
  var iOS = IOSNotificationDetails();
  var platform = new NotificationDetails(android, iOS);
  await flutterLocalNotificationsPlugin
      .show(0, title , message, platform, payload: '');
}
