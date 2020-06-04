import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelCategory.dart';
import 'package:smart_city/model/ModelEvent.dart';
import 'package:smart_city/model/ModelStatus.dart';

class FormAddEvent extends StatefulWidget{

  String _latitude, _longitude;

  FormAddEvent.def() {

  }

  FormAddEvent.LatLon(String _longitude, String _latitude){
    this._longitude = _longitude;
    this._latitude = _latitude;
  }

  @override
  State<StatefulWidget> createState() {
    return FormAddEventState(_latitude, _longitude);
  }

}

class FormAddEventState extends State<FormAddEvent>{

  String _currentCategory;
  int _newCategoryId;
  List<ModelCategory> _categories = null;
  ModelEvent _event = new ModelEvent.def();  

  var _usualTextStyle = TextStyle(fontSize: 16, color: Colors.black);
  var _errorTextStyle = TextStyle(fontSize: 22, color: Colors.red);
  var _successTextStype = TextStyle(fontSize: 22, color: Colors.green);

  FormAddEventState(String _latitude, String _longitude) {
    _event.latitude = double.parse(_latitude);
    _event.longitude = double.parse(_longitude);
  }

  Future<String> _getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("token") == null) {
      return "null";
    } else {
      return preferences.getString("token");
    } 
  }

  final _formKey = GlobalKey<FormState>();
  //List<File> images = new List<File>(); список изображений

  _getEventInformationWidget(){
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Широта: " + _event.latitude.toString(), style: _usualTextStyle),
            new Text("Долгота: " +_event.longitude.toString(), style: _usualTextStyle),
            new TextFormField(
              validator: (value){
                if (value.isEmpty) return "Введите название события";
              },
              onSaved: (value){
                _event.eventName = value;
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Название события")
              ),
            new TextFormField(
              validator: (value){
                if (value.isEmpty) return "Введите описание события";
              },
              onSaved: (value){
                _event.eventDescription = value;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(labelText: "Описание события")
              ),
          ],
        ),
      ),
    );    
  }

  _dropListCategoriesWidget() {
    return DropdownButton(
      value: _currentCategory,
      onChanged: (String newValue) {
        setState(() {
          _currentCategory = newValue;
        });
      },
      hint: Text("Выберите категорию", style: _usualTextStyle),
      items: _categories.map<DropdownMenuItem<String>>((ModelCategory value) {
        return DropdownMenuItem<String>(
          onTap: (){
            _newCategoryId = value.id;
          },
          value: value.categoryName,
          child: Text(value.categoryName),
        );}).toList(),
    );
  }

  _dropBoxCategoryWidget(){
    return Expanded(
      child: SingleChildScrollView(    
      scrollDirection: Axis.horizontal, 
      child: Row(
      children: <Widget>[
        Text("Категория события: ", style: _usualTextStyle),
        Builder(
          builder: (value){
            if (_categories == null){
              return FutureBuilder(
                future: RestApi.getCategories(),
                builder: (context, snapshot){
                  if (snapshot.hasData){
                    if (snapshot.data["success"]){
                      _categories = snapshot.data["data"].map<ModelCategory>((json)=>ModelCategory.fromJson(json)).toList();
                      _currentCategory = _categories[0].categoryName;
                      _newCategoryId = 1;
                      return _dropListCategoriesWidget();
                    } else {
                      return Text(snapshot.data["message"]);
                    }            
                  } else {
                    return CircularProgressIndicator();
                  } 
                },
              );
            } else {
              return _dropListCategoriesWidget();
            }
          },
        ),
      ],
    ),
    ),
    );
  }

  //  _getExpandedImage(){
  //   return Expanded(
  //     flex: 1,      
  //     child: Row(
  //       children: <Widget>[          
  //         Expanded(                                   
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: images.length,
  //             itemBuilder: (context, index) {
  //             final image = images[index];
  //               return  GestureDetector(
  //                 child: Image.file(image),
  //               );
  //             }
  //           )
  //         ),
  //         IconButton(onPressed: () async {
  //           final File photo = await ImagePicker.pickImage(source: ImageSource.gallery);
  //           if (photo != null) {
  //               return showDialog(
  //                   context: context, 
  //                   builder: (BuildContext context) {                          
  //                 return AlertDialog(
  //                   title: Text("Изображение"), 
  //                   content: Image.file(photo),
  //                   actions: <Widget>[
  //                     FlatButton(
  //                     child: Text('Добавить'),
  //                     onPressed: () {
  //                       setState(() {
  //                         images.add(photo);
  //                         Navigator.of(context).pop();                                
  //                       });                              
  //                     }),
  //                   ],
  //                 );
  //               });
  //           }          
  //           },
  //           iconSize: 40.0, 
  //           icon: Icon(Icons.photo_library),
  //           color: Colors.blue,

  //         ),
          
  //       ],
  //     )
  //   );
  // }

  

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
                  //_getExpandedImage(), виджет добавления изображений  
                  RaisedButton(
                    child: Text("Добавить событие"),
                    onPressed: (){
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate()){
                      Future future = _getToken();
                      future.then((value){
                        Future future = RestApi.addEvent(value, _event.eventName, _event.eventDescription, _event.longitude, _event.latitude, _newCategoryId);
                        future.then((value){
                          if(value['success']){
                            Navigator.of(context).pop();                            
                          } else {
                            return showDialog(
                              context: context, 
                              builder: (BuildContext context) {                          
                            return AlertDialog(title: Text("Error"), content: Text(value["message"]));
                          }); 
                          }

                        });
                      });
                         
                    }                      
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