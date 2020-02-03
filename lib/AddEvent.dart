import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatelessWidget{
  String _latitude, _longitude;

  AddEvent.LatLon(String _latitude, String _longitude){
    this._longitude = _longitude;
    this._latitude = _latitude;
  }

  AddEvent.def() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Добавить событие")),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_latitude + " " + _longitude),
          RaisedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Назад"))
        ],
      ),
    );
  }
}