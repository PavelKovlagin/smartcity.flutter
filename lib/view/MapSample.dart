import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:smart_city/model/EventModel.dart';

class MapSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapSampleState();
  }
}

class MapSampleState extends State<MapSample> {

  Geolocator _geolocator;
  Position _position;

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) { print('status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) { print('always status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status) { print('whenInUse status: $status'); });
  }

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    checkPermission();
    updateLocation();
    StreamSubscription positionStream = _geolocator.getPositionStream(locationOptions).listen((Position position) { setState(() {
      _position = position;
    });});
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  
  List<Event> events = [
    new Event(1, "eventName", "eventDescription", 56.143170, 40.388447, "02.02.1999", "02.02.1999", 1, "statusName", 2, "email@mail.ru"),
    new Event(1, "eventName", "eventDescription", 56.142356, 40.389101, "02.02.1999", "02.02.1999", 1, "statusName", 2, "email@mail.ru"),
    new Event(1, "eventName", "eventDescription", 56.141352, 40.388479, "02.02.1999", "02.02.1999", 1, "statusName", 2, "email@mail.ru"),
    new Event(1, "eventName", "eventDescription", 56.139627, 40.392642, "02.02.1999", "02.02.1999", 1, "statusName", 2, "email@mail.ru"),
    new Event(1, "eventName", "eventDescription", 56.129057, 40.406635, "02.02.1999", "02.02.1999", 1, "statusName", 2, "email@mail.ru"),
  ];
  List<Marker> userPosition;
  List<Marker> markers;

  @override
  Widget build(BuildContext context) {
    
    markers = new List<Marker>();
    userPosition = new List<Marker>();
    if(_position != null){userPosition.add(new Marker(
      point: new LatLng(_position.latitude, _position.longitude),
      width: 40,
      height: 40,
      builder: (ctx) => new IconButton(
        icon: Icon(Icons.person_pin_circle),
        iconSize: 40, 
        onPressed: null) 
    ));
    }    
    for(var event in events){
      markers.add(new Marker(
        point: new LatLng(event.latitude, event.longitude),
        width: 40,
        height: 40,
        builder: (ctx) => new IconButton(
          icon: Icon(Icons.location_on), 
          iconSize: 40,
          onPressed: (){
            return showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text(event.eventName),
                  content: Text(event.eventDescription),
                  actions: <Widget>[
                    RaisedButton(onPressed: (){

                    },
                    child: Text("Открыть"),
                    )
                  ],
                );
              }
            );
          }
        )
      ));
    };
    return Scaffold(
      appBar: AppBar(
        title: Text("Карта"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () {
              print('Latitude: ${_position != null ? _position.latitude.toString() : '0'},');
              print('Longitude: ${_position != null ? _position.longitude.toString() : '0'}, ');
              setState(){
                
              }
            },
          )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(56.129057, 40.406635),
          zoom: 10.0,
          minZoom: 8,
          maxZoom: 18,
          plugins: [            
            MarkerClusterPlugin(),
          ],
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "http://tiles.maps.sputnik.ru/{z}/{x}/{y}.png",
          ),
          MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: markers,
            polygonOptions: PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3
            ),
            builder: (context, markers) {
              return FloatingActionButton(
                child: Text(markers.length.toString()),
                onPressed: null,
              );
            },
          ),
          MarkerClusterLayerOptions(
            markers: userPosition,
            builder: (context, userPosition){

            }
          ),
      ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            //Navigator.pushNamed(context, '/addEvent/$_longitude/$_latitude');
          },
          icon: Icon(Icons.add),
          label: Text("Добавить событие")
      ),
    );
  }

//  Future<void> _GoVladimir() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_Vladimir));
//  }
}
