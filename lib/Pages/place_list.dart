import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/place.tile.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:meet_in_the_middle/models/users.dart';
import 'package:provider/provider.dart';

class PlaceList extends StatefulWidget {
  final String nuetral;
  final uid;
  PlaceList(this.nuetral,this.uid);

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  final Firestore db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context) ?? [];
    UserData user;
    for (var u in users) {
      if (widget.uid == u.uid) {
        user = u;
      }
    }
    final places = Provider.of<List<Place>>(context) ?? [];
    return ListView.builder (
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (context, index) {
          if (widget.nuetral == "good") {
            if (places[index].picture != " " &&
                places[index].picture != 'x' &&
                places[index].picture != 'assets/bad.png' &&
            places[index].token == user.token) {
              return PlaceTile(place: places[index]);
            } else {
              return Container();
            }
          } else {
            if (places[index].picture == "assets/bad.png" &&  places[index].token == user.token) {
              return PlaceTile(place: places[index]);
            } else {
              return Container();
            }
          }
        });
  }
}
