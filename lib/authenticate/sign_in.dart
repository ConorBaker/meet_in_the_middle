import 'package:flutter/material.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('Meet In The Middle'),
        actions: <Widget>[
          FlatButton.icon(
              textColor: Colors.white,
            icon: Icon(Icons.person),
            label: Text('Register'),
              onPressed: (){
                widget.toggleView();
            }
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Form(
        child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey[800],
                backgroundImage: AssetImage('assets/LogoNoBlack.jpg'),
                radius: 50,
              ),
              Divider(
                height: 0,
                color: Colors.grey[800],
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white),
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (val){
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 30),
              RaisedButton(
                color: Colors.grey[850],
                child: Text(
                    'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
                  onPressed: () async{
                    print(email);
                    print(password);
             }),
            ],
          ),
        )
      )
      );
  }
}
