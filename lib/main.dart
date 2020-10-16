import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/loading.dart';
import 'package:meet_in_the_middle/Pages/register.dart';
import 'package:meet_in_the_middle/pages/home.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/':(context) => Loading(),
      '/home':(context) => Home(),
      '/register':(context) => Register()
    }
  ));
}






