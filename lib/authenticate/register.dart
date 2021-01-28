import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/shared/constants.dart';
import 'package:meet_in_the_middle/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Color.fromRGBO(163,217,229,1),
        appBar: AppBar(
          title: Text('Meet In The Middle',style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          )),
          elevation: 0.0,
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
          backgroundColor: Color.fromRGBO(163,217,229,1),
        ),
        body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(242,243,245,1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
              )),
          child: Padding(
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
                SizedBox(height: 10),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                  style: TextStyle(color: Colors.black),
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val.length < 6 ? 'Enter a password at least 6 characters long' : null,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 30),
                RaisedButton(
                    color: Colors.white,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            loading = false;
                            error = 'Please Supply A Valid Email Address';
                          });
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
          ),
        )
    );

  }
}
