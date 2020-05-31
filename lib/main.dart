import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_city/view/FormAddEvent.dart';
import 'package:smart_city/view/FormAuth.dart';
import 'package:smart_city/view/FormEvent.dart';

import 'view/FormMapSample.dart';
import 'view/FormProfile.dart';
import 'view/FormRegister.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/map',
      routes: {
        '/addEvent': (BuildContext context) => FormAddEvent.def(),
        '/map': (BuildContext context) => MyApp(),
        '/register': (BuildContext context) => FormRegister(),
        '/event': (BuildContext context) => FormEvent.def(),
        '/profile': (BuildContext context) => FormProfile(),
        '/auth': (BuildContext context) => FormAuth()
      },
      onGenerateRoute: (routeSettings) {
        var path = routeSettings.name.split('/');
        switch (path[1]) {
          case 'addEvent':
            return new MaterialPageRoute(
              builder: (context) => new FormAddEvent.LatLon(path[2], path[3]),
              settings: routeSettings,
            );
            break;
          case 'event':
            return new MaterialPageRoute(
              builder: (context) => new FormEvent.event_id(path[2]),
              settings: routeSettings,
            );
            break;
          case 'profile':
          return new MaterialPageRoute(
            builder: (context) => new FormProfile.user_id(path[2]),
            settings: routeSettings,
          );
          break;
        }
      }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    FormMapSample(),
    FormProfile(),
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
