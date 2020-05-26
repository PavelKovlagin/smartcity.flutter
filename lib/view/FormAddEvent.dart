import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormAddEvent extends StatefulWidget{

  String _latitude, _longitude;

  FormAddEvent.def() {

  }

  FormAddEvent.LatLon(String _latitude, String _longitude){
    this._longitude = _longitude;
    this._latitude = _latitude;
  }

  @override
  State<StatefulWidget> createState() {
    return FormAddEventState(_latitude, _longitude);
  }

}

class FormAddEventState extends State<FormAddEvent>{

  String _latitude, _longitude;

  FormAddEventState(String _latitude, String _longitude) {
    this._latitude = _latitude;
    this._longitude = _longitude;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить событие")),
        body: SingleChildScrollView (
          child: Container(
          padding: EdgeInsets.all(16.0),
            child: new Form(key: _formKey,
              child: new Column(
              children: <Widget>[
                new Text(_latitude),
                new Text(_longitude),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Название события")
                  ),
                new TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(labelText: "Описание события")
                  ),
                new RaisedButton(onPressed: (){
                  
                  },
                  child: Text("Отправить"),
                  color: Colors.blue,
                  textColor: Colors.white,
                  )
                  ],
                ),
            ),
          ), 
        ),
    );
  }
}