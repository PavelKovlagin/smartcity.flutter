import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormProfile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FormProfileState();
  }
}

class FormProfileState extends State<FormProfile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
      ),
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