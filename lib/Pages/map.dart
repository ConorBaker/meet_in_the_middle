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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cPos,
        markers: Set.from(myMarker)
      ),
    );
  }
}
