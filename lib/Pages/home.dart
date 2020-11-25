import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  final AuthService  _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Users>>.value(
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
            onPressed: () async{
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          UserList(),
          RaisedButton(
              color: Colors.grey[850],
              child: Text(
                'Location',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async{
                       
              }),

          /*CircleAvatar(
            backgroundColor: Colors.grey[900],
            backgroundImage: AssetImage('assets/LogoNoBlack.jpg'),
            radius: 150,
          ),*/

          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[],
          ),*/
        ],
      ),
      ),
    );
  }
}
