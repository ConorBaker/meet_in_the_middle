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
         RaisedButton.icon(onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null){
              print('error sigining in');
            }else{
              print('sining in');
              print(result);
            }
        },
            icon: Icon(Icons.account_circle),label: Text('Log In Anonymously'),
          ),
        ]
      ),
      );
  }
}
