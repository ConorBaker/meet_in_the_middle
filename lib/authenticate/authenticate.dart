import 'package:flutter/material.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/authenticate/sign_in.dart';
import 'package:meet_in_the_middle/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Register()
    );

  }
}
