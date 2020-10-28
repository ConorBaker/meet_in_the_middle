import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

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
                label: Text('Sign In'),
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
            key: _formKey,
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
                validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                style: TextStyle(color: Colors.white),
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (val) => val.length < 6 ? 'Enter a password at least 6 characters long' : null,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 30),
              RaisedButton(
                  color: Colors.grey[850],
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if(result == null){
                        setState(() => error = 'Please Supply A Valid Email Address');
                      }
                    }
                  }
                  ),
              SizedBox(height: 12),
              Text(error,
                  style: TextStyle(color: Colors.red, fontSize: 14))
            ],
          ),
        )
        )
    );
  }
}
