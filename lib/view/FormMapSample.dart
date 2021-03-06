import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/DBprovider.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelCategory.dart';
import 'package:smart_city/model/ModelEvent.dart';
import 'package:smart_city/model/ModelStatus.dart';

class FormMapSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormMapSampleState();
  }
}

class FormMapSampleState extends State<FormMapSample> {
  Geolocator _geolocator;
  Position _position;

  String _currentStatus = "Все";
  String _currentCategory = "Все";
  List<ModelCategory> _categories = null;
  List<ModelStatus> _statuses = null;

  double _userLatitude =  56.146405, _userLongitude = 40.379389; //Владимир

  Future<String> _getDateLastUpdate() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dateLastUpdate = preferences.getString("dateLastUpdate");    
    if (dateLastUpdate == null) {
      dateLastUpdate = '0001-1-1';
    }
    return dateLastUpdate;
  }

  Future _setDateLastUpdate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String dateLastUpdate = now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString()+" "+now.hour.toString()+":"+now.minute.toString()+":"+now.second.toString();
    preferences.setString('dateLastUpdate', dateLastUpdate);
  }

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

  Future _getEvents() async {
    Future future = _getDateLastUpdate();
    future.then((value){
      Future future = RestApi.events(value);
      future.then((value){
        if (value["success"]){
          List<ModelEvent>events = value["data"].map<ModelEvent>((json)=>ModelEvent.fromJson(json)).toList();
          DBprovider.db.setEvents(events);
          _setDateLastUpdate(); 
          setState(() {});
        } else {
          _showMyDialog(value["message"].toString());
        }        
      });  
    });    
  }
  
  Future<List<Marker>> _addMarkers(List<ModelEvent> events) async {   
    List<Marker> eventMarkers = new List<Marker>(); 
    for (var event in events) {
        eventMarkers.add(new Marker(
            point: new LatLng(event.latitude, event.longitude),
            width: 40,
            height: 40,
            builder: (ctx) => new GestureDetector(
                child: new Icon(Icons.location_on),
                onTap: () {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(event.eventName),
                          content: Text(event.eventDescription),
                          actions: <Widget>[
                            new RaisedButton(
                              onPressed: () {            
                                Navigator.pushNamed(context, "/event/" + event.id.toString());
                              },
                              child: Text("Открыть"),
                            )
                          ],
                        );
                      });
                })));
    }
    return eventMarkers;
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
    try{
      _geolocator = Geolocator();
      checkPermission();
      updateLocation();
      LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);      
      StreamSubscription positionStream = _geolocator
          .getPositionStream(locationOptions)
          .listen((Position position) {
        setState(() {
          _position = position;
        });
      });
    } catch (Exception) {

    }
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

  _dropListCategories(){
    return DropdownButton(
      value: _currentCategory,
      onChanged: (String newValue) {
        setState(() {
          _currentCategory = newValue;
        });
      },
      hint: Text("Категория"),
      items: _categories.map<DropdownMenuItem<String>>((ModelCategory value) {
        return DropdownMenuItem<String>(
          value: value.categoryName,
          child: Text(value.categoryName),
        );}).toList(),
    );
  }

  _dropListStatuses(){
    return DropdownButton(
      value: _currentStatus,
      onChanged: (String newValue) {
        setState(() {
          _currentStatus = newValue;
        });
      },
      hint: Text("Статус"),
      items: _statuses.map<DropdownMenuItem<String>>((ModelStatus value) {
        return DropdownMenuItem<String>(
          value: value.statusName,
          child: Text(value.statusName),
        );}).toList(),
    );
  }

  _dropLists(){
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
        children: <Widget>[          
          Builder(
            builder: (value){
              if (_statuses == null){
                return FutureBuilder(
                  future: RestApi.statuses(),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      if (snapshot.data["success"]){
                        _statuses = snapshot.data["data"].map<ModelStatus>((json)=>ModelStatus.fromJson(json)).toList();
                        _statuses.add(ModelStatus(0, "Все", "Все статусы")); 
                        return _dropListStatuses();                        
                      } else {
                        return Text(snapshot.data["message"]);                        
                      }            
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return _dropListStatuses();
              }
            },
          ),
          Builder(
            builder: (value){
              if (_categories == null){
                return FutureBuilder(
                  future: RestApi.categories(),
                  builder: (context, snapshot){
                    if (snapshot.hasData){
                      if (snapshot.data["success"]){
                        _categories = snapshot.data["data"].map<ModelCategory>((json)=>ModelCategory.fromJson(json)).toList();
                        _categories.add(ModelCategory(0, "Все", "Все категории")); 
                        return _dropListCategories();                        
                      } else {
                        return Text(snapshot.data["message"]);                        
                      }            
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return _dropListCategories();
              }
            },
          )
        ],
      ),
      )
    );
  }

  _map(){
    return Expanded(
      flex: 7,
      child: FutureBuilder(
      future: DBprovider.db.selectEvents(_currentCategory, _currentStatus),
      builder: (context, snapshot) {        
        if (snapshot.hasData){
          return FutureBuilder(
            future: _addMarkers(snapshot.data),
            builder: (context, snapshot){
            if (snapshot.hasData){              
              return FlutterMap(
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
                      markers: snapshot.data,
                      polygonOptions: PolygonOptions(
                          borderColor: Colors.blueAccent,
                          color: Colors.black12,
                          borderStrokeWidth: 3),
                      builder: (context, markers) {
                        return new Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.blue),
                          child: Text(markers.length.toString(), style: TextStyle(color: Colors.white),),
                        );
                      },
                    ),
                    MarkerClusterLayerOptions(
                        markers: userPosition,
                        builder: (context, userPosition) {}),
                  ],
                );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    ),
    );
  }

  _panel(){
    return Expanded(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new IconButton(
          onPressed: () {
              Navigator.pushNamed(context,
                  '/addEvent/${_position.longitude.toString()}/${_position.latitude.toString()}');
          },
          icon: new Icon(Icons.add_circle),
          color: Colors.blue,
        ),

      ],
    ),
    );
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
          builder: (ctx) => new GestureDetector(
              child: new Icon(Icons.person_pin_circle),
              onTap: null)));
    } else {

    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Карта"),
        actions: <Widget>[                    
          new IconButton(
            icon: new Icon(Icons.update),
            onPressed: () {
              _getEvents();
            },
          ),
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: (){
              if (_position == null){
                _showMyDialog("Позиция не определена. Возможно не включен GPS");                
              } else {             
                Navigator.pushNamed(context,
                  '/addEvent/${_position.longitude.toString()}/${_position.latitude.toString()}'); 
              }                           
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[          
          _dropLists(),
          _map(),          
          //_panel(),
        ],
      ),
    );
  }
}
