import 'package:flutter/material.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/authenticate/authenticate.dart';
import 'package:meet_in_the_middle/Pages/home.dart';
import 'package:meet_in_the_middle/Pages/map.dart';
import 'package:meet_in_the_middle/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
