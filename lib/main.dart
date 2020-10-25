import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/loading.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/authenticate/register.dart';
import 'file:///C:/Users/Conor/AndroidStudioProjects/meet_in_the_middle/lib/services/auth.dart';
import 'package:meet_in_the_middle/pages/home.dart';
import 'package:meet_in_the_middle/Pages/wrapper.dart';
import 'package:meet_in_the_middle/Pages/homePage.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
      ),
    );
  }
}







/*initialRoute: '/wrapper',
routes: {
'/':(context) => Loading(),
'/wrapper':(context) => Wrapper(),
'/home':(context) => Home(),
'/register':(context) => Register(),
'/homePage':(context) => HomePage()
}*/