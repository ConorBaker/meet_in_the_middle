import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_in_the_middle/Pages/place_list.dart';
import 'package:meet_in_the_middle/Pages/settings_form.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:meet_in_the_middle/services/auth.dart';
import 'package:meet_in_the_middle/services/database.dart';
import 'package:meet_in_the_middle/shared/approve_locations.dart';
import 'package:meet_in_the_middle/shared/category_selector.dart';
import 'package:meet_in_the_middle/shared/currernt_login.dart';
import 'package:meet_in_the_middle/shared/family_maker.dart';
import 'package:meet_in_the_middle/shared/join_family.dart';
import 'package:provider/provider.dart';

class bad_places extends StatefulWidget {
  @override
  _bad_placesState createState() => _bad_placesState();
}

class _bad_placesState extends State<bad_places> {
  final AuthService _auth = AuthService();
  final Firestore db = Firestore.instance;
  @override
  Widget build(BuildContext context) {


    return StreamProvider<List<Place>>.value(
      value: DataBaseService().places,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(163, 217, 229, 1),
        body: Column(
          children: <Widget>[
            CategorySelector(2),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 243, 245, 1),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: PlaceList("bad")
              ),
            ),
          ],
        ),
      ),
    );
  }
}

