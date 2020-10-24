import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState                  createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingIn()
    );

  }
}
