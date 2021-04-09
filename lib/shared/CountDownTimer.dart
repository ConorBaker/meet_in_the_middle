import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meet_in_the_middle/Pages/map.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/models/SizeConfig.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/CustomTimerPainter.dart';
import 'package:meet_in_the_middle/shared/approve_locations.dart';
import 'package:meet_in_the_middle/shared/currernt_login.dart';
import 'package:meet_in_the_middle/shared/family_maker.dart';
import 'package:meet_in_the_middle/shared/join_family.dart';
import 'CustomTimerPainter.dart';

class CountDownTimer extends StatefulWidget {

  final UserData user;
  CountDownTimer(this.user);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 15),
    );
    if (controller.isAnimating) {
      controller.stop();
    }
    else {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    }
  }

  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;

  void start(){
    UserData user = widget.user;
    Future.delayed(Duration(minutes: 15), () async {
      DocumentSnapshot variable = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get();
      var spl = variable.data['message'].split("_");
      if (spl[0] == "waiting" || spl[0] == "request") {
        var dlat = double.parse(user.lat.toString());
        var dlng = double.parse(user.lng.toString());
        Navigator.pop(context);
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
        showNotification("Location request is now available to view" );
      }else{
        showNotification("Location request has been denied by " + user.name);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    start();
    SizeConfig().init(context);
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

    return Scaffold(
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
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(242, 243, 245, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(),
                        ),
                        Padding(
                          padding: EdgeInsets.all(50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: FractionalOffset.center,
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: CustomPaint(
                                              painter: CustomTimerPainter(
                                            animation: controller,
                                            backgroundColor: Color.fromRGBO(73, 140, 166, 1),
                                            color: Color.fromRGBO(59, 75, 126,1),
                                          )),
                                        ),
                                        Align(
                                          alignment: FractionalOffset.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Time remaining until \n" + widget.user.name +"'s  \n location is available",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                timerString,
                                                style: TextStyle(
                                                    fontSize: 75,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            )),
          ],
        ));
  }

  showNotification(String message) async {
    var android = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Meet In The Middle',
        message,
        platform,
        payload: '');
  }
}
