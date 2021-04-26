import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:meet_in_the_middle/services/database.dart';

class approval extends StatefulWidget {
  final String id;
  final String address;
  final String token;

  approval({this.id, this.address,this.token});

  @override
  _approvalState createState() => _approvalState();
}

class _approvalState extends State<approval> {
  Future<DocumentSnapshot> getPlace() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('places')
        .document(widget.id.toString())
        .get();
    return variable;
  }

  Future<String> getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser cUser = await _auth.currentUser();
    String currentUserId = cUser.uid;
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .get();
    String token = variable.data['token'];
    return token;
  }



  int selectedIndex = 0;
  String _currentName;

  @override
  Widget build(BuildContext context) {
    final List<String> pictures = [
      'assets/home.png',
      'assets/school.png',
      'assets/restaurant.png',
      'assets/bus.png',
      'assets/shopping.png',
      'assets/tree.png',
      'assets/soccer.png',
      'assets/bar.png',
      'assets/church.png'
    ];




    int selection = 0;
    return Column(
      children: <Widget>[
        Column(
          children: [
            Text(
                "Seems like you have visited this place often! Would you like to add it to your safe places?",
                style: TextStyle(
                  fontSize: 15.0,
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                initialValue: widget.address,
                validator: (val) => val.isEmpty ? 'Please Enter a Name' : null,
                onChanged: (val) => setState(() => _currentName = val),
              ),
            )
          ],
        ),
        Container(
          height: 100,
          child: ListView.builder(
              padding: EdgeInsets.only(left: 10.0),
              scrollDirection: Axis.horizontal,
              itemCount: pictures.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedIndex = index;
                    });
                    setState(() {
                      selection = index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: index == selectedIndex
                            ? Colors.grey
                            : Colors.white,
                        child: CircleAvatar(
                          radius: 35.0,
                          backgroundImage: AssetImage(pictures[index]),
                        )),
                  ),
                );
              }),
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Yes, Id consider this a place safe'),
                onPressed: () async {
                  DocumentSnapshot variable = await Firestore.instance
                      .collection('places')
                      .document(widget.id.toString())
                      .get();
                  await DataBaseService(uid: widget.id).updatePlaceData(
                      _currentName ?? variable.data['name'],
                      variable.data['lat'],
                      variable.data['lng'],
                      variable.data['day'],
                      pictures[selectedIndex], "", widget.token,
                  );
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text('No, I do not consider this place safe'),
                onPressed: () async {
                  DocumentSnapshot variable = await Firestore.instance
                      .collection('places')
                      .document(widget.id.toString())
                      .get();
                  await DataBaseService(uid: widget.id).updatePlaceData(
                      variable.data['name'],
                      variable.data['lat'],
                      variable.data['lng'],
                      variable.data['day'],
                      "assets/bad.png",
                      "",widget.token);
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text('Im not familiar with this location'),
                onPressed: () async {
                  DocumentSnapshot variable = await Firestore.instance
                      .collection('places')
                      .document(widget.id.toString())
                      .get();
                  await DataBaseService(uid: widget.id).updatePlaceData(
                      variable.data['name'],
                      variable.data['lat'],
                      variable.data['lng'],
                      variable.data['day'],
                      "x",
                      "",widget.token);
                  Navigator.pop(context);
                },
              ),
            ])
      ],
    );
  }
}
