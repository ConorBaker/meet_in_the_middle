import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/Pages/place_list.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/Pages/user_list.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/category_selector.dart';
import 'package:provider/provider.dart';

class users extends StatefulWidget {

  @override
  usersState createState() => usersState();

}

class usersState extends State<users> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
        value: DataBaseService().users,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(163, 217, 229, 1),

          body: Column(
            children: [
              CategorySelector(0),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(242, 243, 245, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: UserList()),
              ),
            ],
          ),


        )
    );
  }

}