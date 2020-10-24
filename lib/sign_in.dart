import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/auth.dart';

class SingIn extends StatefulWidget {
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Meet In The Middle'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: RaisedButton.icon(onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null){
              print('error sigining in');
            }else{
              print('sining in');
            }
        },
            icon: Icon(Icons.account_circle),label: Text(' Log In Anon'),
          ),
        ),
      );
  }
}
