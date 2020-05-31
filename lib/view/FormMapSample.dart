import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelEvent.dart';

class FormMapSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormMapSampleState();
  }
}

class FormMapSampleState extends State<FormMapSample> {
  Geolocator _geolocator;
  Position _position;

  double _userLatitude =  56.146405, _userLongitude = 40.379389; //Владимир
  //double _userLatitude =  55.753076, _userLongitude = 37.667272; //Москва

  double _zoom = 10;

  Future<void> _showMyDialog(String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Понятно'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  List<Marker> eventMarkers = new List<Marker>();

  Future _getEvents() async {
    var events = await RestApi.getEventsResponse("2000-05-26 11:11:11");
    return events;
  }

  Future _getEvent(String event_id) async {
    var event = await RestApi.getEventResponse(event_id);
    return event;
  }
  
  addMarkers(List<ModelEvent> events) {   
    eventMarkers = new List<Marker>(); 
    for (var event in events) {
      if (event.visibilityForUser == 1) {
        eventMarkers.add(new Marker(
            point: new LatLng(event.latitude, event.longitude),
            width: 40,
            height: 40,
            builder: (ctx) => new IconButton(
                icon: Icon(Icons.location_on),
                iconSize: 40,
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(event.eventName),
                          content: Text(event.eventDescription),
                          actions: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                // Future future = _getEvent(event.event_id.toString());
                                // future.then((content){
                                //   if (content["success"]){
                                //     print(content["success"]);
                                //     print(content["data"]);
                                //     Event event = Event.fromJson(content["data"]["event"]);
                                //     print(event.eventName); 
                                //   } else {
                                //     _showMyDialog(content["message"].toString());
                                //   }             
                                Navigator.pushNamed(context, "/event/" + event.event_id.toString());
                              },
                              child: Text("Открыть"),
                            )
                          ],
                        );
                      });
                })));
      }
    }
  }

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    checkPermission();
    updateLocation();
    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      setState(() {
        _position = position;
      });
    });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  List<Marker> userPosition;

  @override
  Widget build(BuildContext context) {
    userPosition = new List<Marker>();
    if (_position != null) {
      _userLatitude = _position.latitude;
      _userLongitude = _position.longitude;
      userPosition.add(new Marker(
          point: new LatLng(_userLatitude, _userLongitude),
          width: 40,
          height: 40,
          builder: (ctx) => new IconButton(
              icon: Icon(Icons.person_pin_circle),
              iconSize: 40,
              onPressed: null)));
    } else {

    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Карта"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              // print(
              //     'Latitude: ${_position != null ? _position.latitude.toString() : '0'},');
              // print(
              //     'Longitude: ${_position != null ? _position.longitude.toString() : '0'}, ');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          new Expanded(
                  child: new FlutterMap(
                    options: MapOptions(
                      center: LatLng(_userLatitude, _userLongitude),
                      zoom: _zoom,
                      minZoom: 8,
                      maxZoom: 18,
                      plugins: [
                        MarkerClusterPlugin(),
                      ],
                    ),
                    layers: [
                      new TileLayerOptions(
                        urlTemplate:
                            "http://tiles.maps.sputnik.ru/{z}/{x}/{y}.png",
                      ),
                      MarkerClusterLayerOptions(
                        maxClusterRadius: 120,
                        fitBoundsOptions: FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                        ),
                        markers: eventMarkers,
                        polygonOptions: PolygonOptions(
                            borderColor: Colors.blueAccent,
                            color: Colors.black12,
                            borderStrokeWidth: 3),
                        builder: (context, markers) {
                          return new FloatingActionButton(
                            child: Text(markers.length.toString()),
                            onPressed: null,
                          );
                        },
                      ),
                      MarkerClusterLayerOptions(
                          markers: userPosition,
                          builder: (context, userPosition) {}),
                    ],
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                onPressed: () {
                   Navigator.pushNamed(context,
                       '/addEvent/${_position.longitude.toString()}/${_position.latitude.toString()}');
                },
                iconSize: 80 ,
                icon: Icon(Icons.add_circle),
                color: Colors.blue,
              ),
              new IconButton(
                  onPressed: () {                                                  
                    setState(() {
                      Future future = _getEvents();
                      future.then((content){
                        if (content["success"]){
                          
                          setState(() {
                            print(content["success"]);
                          print(content["data"]);
                          List<ModelEvent>events = content["data"].map<ModelEvent>((json)=>ModelEvent.fromJson(json)).toList();
                          addMarkers(events);
                          });
                        } else {
                          _showMyDialog(content["message"].toString());
                        }                     
                        
                      }); 
                    });
                  },
                  iconSize: 80,
                  icon: Icon(Icons.center_focus_strong),
                  color: Colors.blue)
            ],
          )
        ],
      ),
    );
  }
}
