import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/loading.dart';
import 'package:meet_in_the_middle/Pages/register.dart';
import 'package:meet_in_the_middle/pages/home.dart';
import 'package:meet_in_the_middle/Pages/wrapper.dart';
import 'package:meet_in_the_middle/Pages/homePage.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/wrapper',
    routes: {
      '/':(context) => Loading(),
      '/wrapper':(context) => Wrapper(),
      '/home':(context) => Home(),
      '/register':(context) => Register(),
      '/homePage':(context) => HomePage()
    }
  ));
}






