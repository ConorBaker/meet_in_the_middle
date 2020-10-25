import 'package:flutter/material.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/services/auth.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {

  final AuthService  _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.grey[900],
            backgroundImage: AssetImage('assets/LogoNoBlack.jpg'),
            radius: 100,
          ),
          Divider(
            height: 100,
            color: Colors.grey[900],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[],
          ),
        ],
      ),
    );
  }
}
