import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  Home_State createState() => Home_State();
}

class Home_State extends State<Home> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[],
          ),
          RaisedButton.icon(onPressed: (){

  },
            icon: Icon(Icons.account_circle),label: Text('Login'),
          ),
          RaisedButton.icon(onPressed: (){
            Navigator.pushNamed(context, '/register');
          },
            icon: Icon(Icons.account_circle),label: Text('Register'),
          ),
        ],
      ),
    );
  }
}
