import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/Pages/place.tile.dart';
import 'package:meet_in_the_middle/models/place.dart';
import 'package:provider/provider.dart';

class PlaceList extends StatefulWidget {
  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  Place placeData;
  @override
  Widget build(BuildContext context) {
    final places = Provider.of<List<Place>>(context) ?? [];
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (context, index) {
          if(places[index].picture != " " && places[index].picture != 'x'){
            return PlaceTile(place: places[index]);
          }else{
            return Container();
          }
        });
  }
}
