import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          RaisedButton(onPressed: (){
            Navigator.pushNamed(context, '/register');
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Text("Регистрация"),
          ),
          RaisedButton(onPressed: (){
            Navigator.pushNamed(context, "/event");
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Text("Событие"),
          )
        ],
      ),
      ),
    );
  }
}