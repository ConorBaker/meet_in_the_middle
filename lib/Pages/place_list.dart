import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/place.tile.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:provider/provider.dart';

class PlaceList extends StatefulWidget {
  final String nuetral;

  PlaceList(this.nuetral);

  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>>(context) ?? [];
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (context, index) {
          if (widget.nuetral == "good") {
            if (places[index].picture != " " &&
                places[index].picture != 'x' &&
                places[index].picture != 'assets/bad.png') {
              return PlaceTile(place: places[index]);
            } else {
              return Container();
            }
          } else {
            if (places[index].picture == "assets/bad.png") {
              return PlaceTile(place: places[index]);
            } else {
              return Container();
            }
          }
        });
  }
}
