import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meet_in_the_middle/models/place.dart';
class PlaceTile extends StatelessWidget {
  final Place place;

  PlaceTile({this.place});

 String userid;



  @override
  Widget build(BuildContext context) {
    String attending = "";
    if(place.people != null){
      var allPeople = place.people.split("_");
      for(int x = 0; x < allPeople.length; x++){
        attending = attending + allPeople[x] + " ";
      }
    }
    return Padding(
        padding: EdgeInsets.only(top: 0.0),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          margin: EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[900],
              backgroundImage: AssetImage(place.picture),
            ),
            title: Text(place.name, style: TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.w500,
            )),
            subtitle: Text(attending),
            trailing: Icon(Icons.more_vert),
          ),
        ));
  }
}