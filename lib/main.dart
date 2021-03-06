import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_city/view/FormAddEvent.dart';
import 'package:smart_city/view/FormChangePassword.dart';
import 'package:smart_city/view/FormEvent.dart';
import 'package:smart_city/view/FormSendCode.dart';

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
        '/sendCode': (BuildContext context) => FormSendCode()
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
          case 'changePassword':
          return new MaterialPageRoute(
            builder: (context) => new FormChangePassword(path[2]),
            settings: routeSettings,
          );
          break;

        }
      }));
}

class MyApp extends StatelessWidget {

  

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return Home();
  }
}

class Home extends StatefulWidget {

  var _usualTextStyle = TextStyle(fontSize: 16, color: Colors.black);
  var _errorTextStyle = TextStyle(fontSize: 22, color: Colors.red);
  var _successTextStype = TextStyle(fontSize: 22, color: Colors.green);

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
