import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_city/AddEvent.dart';


class MapSample extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MapSampleState();
  }
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  static double _latitude = 45.123453, _longitude = 55.326584;
  static final CameraPosition _kGooglePlex =
  CameraPosition(target: LatLng(_latitude, _longitude), zoom: 14.4746
  );

  static final CameraPosition _Vladimir = CameraPosition(
      bearing: 192.833490,
      target: LatLng(56.126880, 40.397106),
      tilt: 59.440771,
      zoom: 19.151926
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GoogleMap(
      mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      }
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.pushNamed(context, '/addEvent/$_longitude/$_latitude');
      }, icon: Icon(Icons.add,),
        label: Text("Добавить событие")
      ),
    );
  }

//  Future<void> _GoVladimir() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_Vladimir));
//  }
}