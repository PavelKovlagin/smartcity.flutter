import 'dart:async';


import 'package:flutter/material.dart';
import 'package:smart_city/view/AddEvent.dart';
import 'package:smart_city/view/FormEvent.dart';

import 'view/MapSample.dart';
import 'view/Profile.dart';
import 'view/Register.dart';

void main(){
  runApp(MaterialApp(
    initialRoute: '/map',
    routes: {
      '/addEvent': (BuildContext context) => AddEvent.def(),
      '/map': (BuildContext context) => MyApp(),
      '/register': (BuildContext context) => Register(),
      '/event': (BuildContext context) => FormEvent()
    },
      onGenerateRoute: (routeSettings){
      var path = routeSettings.name.split('/');

      if (path[1] == 'addEvent') {
        return new MaterialPageRoute(
          builder: (context) => new AddEvent.LatLon(path[2], path[3]),
          settings: routeSettings,
        );
      }
    }
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MapSample(),
    Profile(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}

