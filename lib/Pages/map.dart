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
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  GoogleMapController _controller;

  void getCurrentLocation() async {
    try {
      var location = await _locationTracker.getLocation();

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
            if (_controller != null) {
              _controller.animateCamera(
                  CameraUpdate.newCameraPosition(new CameraPosition(
                      bearing: 192.8334901395799,
                      target: LatLng(
                          newLocalData.latitude, newLocalData.longitude),
                      tilt: 0,
                      zoom: 18.00)));
            }
          });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

 /* void _onMapCreate(GoogleMapController cntrl) {
    _controller = cntrl;
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
  }
*/

  @override
  Widget build(BuildContext context) {
     final CameraPosition cPos = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 14.4746,
    );
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cPos,
        //onMapCreated: _onMapCreate,
      ),
    );
  }


}