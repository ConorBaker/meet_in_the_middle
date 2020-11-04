import 'package:flutter/material.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/services/auth.dart';
import 'package:meet_in_the_middle/shared/constants.dart';
import 'package:meet_in_the_middle/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ?  Loading() : Scaffold(
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
          key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            /*  CircleAvatar(
                backgroundColor: Colors.grey[800],
                backgroundImage: AssetImage('assets/LogoNoBlack.jpg'),
                radius: 20,
              ),*/
              Divider(
                height: 0,
                color: Colors.grey[800],
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                style: TextStyle(color: Colors.black),
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length < 6 ? 'Enter a password at least 6 characters long' : null,
                style: TextStyle(color: Colors.black),
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
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result == null){
                        setState(() {
                          error = 'Failed To Sign In';
                          loading = false;
                        });
                      }
                    }
             }),
              SizedBox(height: 12),
              Text(error,
              style: TextStyle(color: Colors.red, fontSize: 14))
            ],
          ),
        )
      )
      );
    //gitFix
  }
}
