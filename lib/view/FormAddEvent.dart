import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelCategory.dart';
import 'package:smart_city/model/ModelStatus.dart';

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
  String currentStatus;
  String currentCategory;

  FormAddEventState(String _latitude, String _longitude) {
    this._latitude = _latitude;
    this._longitude = _longitude;
  }

  final _formKey = GlobalKey<FormState>();
   List<File> images = new List<File>();

  _getEventInformationWidget(){
    return Expanded(
      flex: 3,
      child: SingleChildScrollView(
        child: Column(
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
          ],
        ),
      ),
    );    
  }

  _dropBoxCategoryWidget(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
      children: <Widget>[
        FutureBuilder(
          future: RestApi.getStatuses(),
          builder: (context, snapshot){
            if (snapshot.hasData){
              if (snapshot.data["success"]){
                List<ModelStatus> statuses = snapshot.data["data"].map<ModelStatus>((json)=>ModelStatus.fromJson(json)).toList();
           
                return DropdownButton(
                  value: currentStatus,
                  onChanged: (String newValue) {
                    setState(() {
                      currentStatus = newValue;
                    });
                  },
                  hint: Text("Статус"),
                  items: statuses.map<DropdownMenuItem<String>>((ModelStatus value) {
                    return DropdownMenuItem<String>(
                      value: value.statusName,
                      child: Text(value.statusName),
                    );}).toList(),
                );
              } else {
                return Text(snapshot.data["message"]);                
              }            
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        FutureBuilder(
            future: RestApi.getCategories(),
            builder: (context, snapshot){
              if (snapshot.hasData){
                if (snapshot.data["success"]){
                  List<ModelCategory> categories = snapshot.data["data"].map<ModelCategory>((json)=>ModelCategory.fromJson(json)).toList();
                  categories.add(ModelCategory(0, "Все", "Все категории")); 
                  print(categories.length);             
                  return DropdownButton(
                    value: currentCategory,
                    onChanged: (String newValue) {
                      setState(() {
                        currentCategory = newValue;
                      });
                    },
                    hint: Text("Категория"),
                    items: categories.map<DropdownMenuItem<String>>((ModelCategory value) {
                      return DropdownMenuItem<String>(
                        value: value.categoryName,
                        child: Text(value.categoryName),
                      );}).toList(),
                  );
                } else {
                  return Text(snapshot.data["message"]);
                  
                }            
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
      ],
    ),
    );
  }

   _getExpandedImage(){
    return Expanded(
      flex: 1,      
      child: Row(
        children: <Widget>[
          
          Expanded(                                   
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
              final image = images[index];
                return  GestureDetector(
                  child: Image.file(image),
                );
              }
            )
          ),
          IconButton(onPressed: () async {
            final File photo = await ImagePicker.pickImage(source: ImageSource.gallery);
            if (photo != null) {
                return showDialog(
                    context: context, 
                    builder: (BuildContext context) {                          
                  return AlertDialog(
                    title: Text("Изображение"), 
                    content: Image.file(photo),
                    actions: <Widget>[
                      FlatButton(
                      child: Text('Добавить'),
                      onPressed: () {
                        setState(() {
                          images.add(photo);
                          Navigator.of(context).pop();                                
                        });                              
                      }),
                    ],
                  );
                });
            }          
            },
            iconSize: 40.0, 
            icon: Icon(Icons.photo_library),
            color: Colors.blue,

          ),
          
        ],
      )
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить событие")),
        body: Container(
          padding: EdgeInsets.all(16.0),
            child: new Form(key: _formKey,
              child: new Column(
              children: <Widget>[  
                  _getEventInformationWidget(),
                  _dropBoxCategoryWidget(),              
                  _getExpandedImage(),  
                  RaisedButton(
                    child: Text("Добавить событие"),
                    onPressed: (){

                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                  )             
                  ],
                ),
            ),
        ),
    );
  }
}