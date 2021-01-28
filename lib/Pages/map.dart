import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapScreen(this.latitude, this.longitude);

  @override
  MapSampleState createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  GoogleMapController controller;
  List<Marker> myMarker = [];

  @override
  Widget build(BuildContext context) {
    myMarker = [];
    myMarker.add(Marker(
        markerId: MarkerId("Here"),
        position: LatLng(widget.latitude, widget.longitude),
        draggable: false));
    final CameraPosition cPos = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 14.4746,
    );
    return new Scaffold(
      backgroundColor: Color.fromRGBO(163,217,229,1),
      appBar: AppBar(
        title: Text('Meet In The Middle',style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        )),
        backgroundColor: Color.fromRGBO(163,217,229,1),
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(242,243,245,1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            )),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: cPos,
          markers: Set.from(myMarker)
        ),
      ),
    );
  }
}
