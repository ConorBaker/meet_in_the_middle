import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/models/SizeConfig.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/shared/approve_locations.dart';
import 'package:meet_in_the_middle/shared/category_selector.dart';
import 'package:meet_in_the_middle/shared/currernt_login.dart';
import 'package:meet_in_the_middle/shared/family_maker.dart';
import 'package:meet_in_the_middle/shared/join_family.dart';

class Graph extends StatefulWidget {
  final UserData user;
  final List<String> keys;
  final List<int> values;

  Graph(this.user, this.keys, this.values);

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;

  final GlobalKey<AnimatedCircularChartState> _chartKey =
  new GlobalKey<AnimatedCircularChartState>();

  @override
  Widget build(BuildContext context) {
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
          CategorySelector(4),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 243, 245, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      AnimatedCircularChart(
                        key: _chartKey,
                        size: const Size(400, 400),
                        initialChartData: cycleSamples(),
                        chartType: CircularChartType.Pie,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Table(
                          textDirection: TextDirection.rtl,
                          defaultVerticalAlignment: TableCellVerticalAlignment
                              .bottom,
                          children: [
                            TableRow(children: [
                              Icon(Icons.circle,
                                  color: Color.fromRGBO(75, 105, 150, 1),
                                  size: 25),
                              Text(getName(0) + " " + getNumber(widget.values[0].round())
                                  .toString()+ "%"),
                            ]),
                            TableRow(children: [
                              Icon(Icons.circle,
                                  color: Color.fromRGBO(73, 140, 166, 1),
                                  size: 25),
                              Text(getName(1)+ " " + getNumber(widget.values[1].round())
                                  .toString()+ "%"),
                            ]),
                            TableRow(children: [
                              Icon(Icons.circle,
                                  color: Color.fromRGBO(60, 168, 167, 1),
                                  size: 25),
                              Text(getName(2)+ " " + getNumber(widget.values[2].round())
                                  .toString()+ "%"),
                            ]),
                            TableRow(children: [
                              Icon(Icons.circle,
                                  color: Color.fromRGBO(158, 217, 198, 1),
                                  size: 25),
                              Text(getName(3)+ " " + getNumber(widget.values[3].round())
                                  .toString()+ "%"),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  List<CircularStackEntry> cycleSamples() {
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
              widget.values[0].toDouble(), Color.fromRGBO(75, 105, 150, 1),
              rankKey: widget.keys[0]),
          new CircularSegmentEntry(
              widget.values[1].toDouble(), Color.fromRGBO(73, 140, 166, 1),
              rankKey: widget.keys[1]),
          new CircularSegmentEntry(
              widget.values[2].toDouble(), Color.fromRGBO(60, 168, 167, 1),
              rankKey: widget.keys[2]),
          new CircularSegmentEntry(
              widget.values[3].toDouble(), Color.fromRGBO(158, 217, 198, 1),
              rankKey: widget.keys[3]),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];
    return nextData;
  }

  String getName(int x) {
    String rName = "";
    var name = widget.keys[x].split("_");
    for (int i = 0; i < name.length; i++) {
      rName = rName + name[i] + " ";
    }
    return "\n" + rName;
  }

  int getNumber(int x) {
    double total = 0;
    for (int i = 0; i < widget.values.length; i++) {
      total = total + widget.values[i].toDouble();
    }
    return ((x / total) * 100).toInt();
  }
}