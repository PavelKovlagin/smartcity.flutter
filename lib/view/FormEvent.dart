import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelCategory.dart';
import 'package:smart_city/model/ModelEvent.dart';
import 'package:smart_city/model/ModelStatus.dart';
import 'package:smart_city/model/ModelUser.dart';

class FormEvent extends StatefulWidget {

  String _event_id;

  FormEvent.def(){

  }

  FormEvent.event_id(String event_id) {
    this._event_id = event_id;
  }
  
  @override
  State<StatefulWidget> createState() {
    return FormEventState(_event_id);    
  }
}

class FormEventState extends State<FormEvent> {

  ModelEvent _event = ModelEvent.def();
  ModelUser _user = new ModelUser.empty(); 
  List<ModelCategory> _categories = null;
  List<ModelStatus> _statuses = null;
  //List<File> _images = new List<File>(); список изображений

  String _event_id;
  String _currentCategory;
  int _newCategoryId;

  FormEventState(String event_id){
    this._event_id = event_id;
  }

  Future<String> _getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("token") == null) {
      return "null";
    } else {
      return preferences.getString("token");
    } 
  }

  @override
  void initState() {
    super.initState();
    
  }

  _showDialogImage(String image){
    return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Image.network(image),
        actions: <Widget>[
          FlatButton(
            child: Text('Закрыть'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  _showDialogImageFile(File image){
    return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Image.file(image),
        actions: <Widget>[
          FlatButton(
            child: Text('Закрыть'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  _eventInformationNotEditWidget(){
    return Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text("Название события: " + _event.eventName),
            Text("Описание события: " + _event.eventDescription),
            Text("Статус события: " + _event.statusName),
            Row(
              children: <Widget>[
                Text("Пользователь: "), 
                InkWell(child: Text(_event.email, style: TextStyle(color: Colors.blue)), 
                  onTap: (){
                    Navigator.pushNamed(context, "/profile/" + _event.user_id.toString());
                    
                  }
                  
                )
              ]
            ), 
            Text("Широта: " + _event.latitude.toString()),
            Text("Долгота: " + _event.longitude.toString()),
            ],
          ),  
        ),
      );
  }

  _dropListCategories(List<ModelCategory> categories){
    return DropdownButton(
      value: _currentCategory,
      onChanged: (String newValue) {
        setState(() {
          _currentCategory = newValue;
        });
      },
      hint: Text("Категория"),
      items: categories.map<DropdownMenuItem<String>>((ModelCategory value) {
        return DropdownMenuItem<String>(
          value: value.categoryName,
          onTap: (){
            _newCategoryId = value.id;
          },
          child: Text(value.categoryName),
        );}).toList(),
    );
  }

  _eventInformationEditWidget(){
    final _formKeyEvent = GlobalKey<FormState>();    
    return Form(
      key: _formKeyEvent,
        child: Expanded(
          flex: 3,
          child: Column(
          children: <Widget>[
             RaisedButton(
              child: Text("Редактировать"),
              onPressed: (){
                _formKeyEvent.currentState.save();
                print(_event.toString());
                if (_formKeyEvent.currentState.validate())
                {
                  Future future = _getToken();
                  future.then((value){
                    Future future = RestApi.updateEvent(value, _event.id, _event.eventName, _event.eventDescription, _event.longitude, _event.latitude, _newCategoryId);
                    future.then((value){
                      if (value["success"]){
                        setState(() {});
                      } else {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(title: Text("Error"), content: Text(value["message"]));
                          });
                      }
                    });
                  });
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
            ),
            Expanded(   
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[                   
                    Row(
                      children: <Widget>[
                        Text("Пользователь: "),
                        InkWell(child: Text(_event.email, style: TextStyle(color: Colors.blue)), 
                        onTap: () {
                          Navigator.pushNamed(context, "/profile/" + _event.user_id.toString()).then((value){
                            
                          });
                          
                        })
                      ],
                    ), 
                    Text("Широта: " + _event.latitude.toString()),
                    Text("Долгота: " + _event.longitude.toString()), 
                    Text("Статус события: " + _event.statusName),
                    Builder(builder: (value){
                      if (_categories == null){
                        return FutureBuilder(
                          future: RestApi.getCategories(),
                          builder: (context, snapshot){
                            if (snapshot.hasData){
                              if (snapshot.data["success"]){
                                _categories = snapshot.data["data"].map<ModelCategory>((json)=>ModelCategory.fromJson(json)).toList();                        
                                _currentCategory = _event.categoryName;
                                return _dropListCategories(_categories);        
                              } else {
                                return Text(snapshot.data["message"]);                    
                              }            
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      } else {
                        return _dropListCategories(_categories);
                      }
                    }),
                    
                    TextFormField(validator: (value){
                      if (value.isEmpty) return "Введите название события";
                    },
                    onSaved: (value){
                      _event.eventName = value;
                    },
                    initialValue: _event.eventName,
                    decoration: InputDecoration(labelText: "Название события"),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    ),
                    TextFormField(validator: (value){
                      if (value.isEmpty) return "Введите описание события";
                    },
                    onSaved: (value){
                      _event.eventDescription = value;
                    },
                    initialValue: _event.eventDescription,
                    decoration: InputDecoration(labelText: "Описание события"),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    
                    ),
                  ],
                )
              )
            ),
          ],
        ),
        )
    );
  }

  _getExpandedComments(){
    return Expanded(
      flex: 2,
      child: ListView.builder(                        
        itemCount: _event.comments.length,
          itemBuilder: (context, index) {
            final comment = _event.comments[index];
            return Card(
              child: Column (
                children: <Widget>[                
                  ListTile(
                    title: Row(children: <Widget>[
                      Expanded(
                        child: InkWell(
                      child: Text(comment.email, style: TextStyle(color: Colors.blue)),
                        onTap: () {
                          Navigator.pushNamed(context,'/profile/' + comment.user_id.toString()); 
                        },
                      ),
                      ),
                      Expanded(child: Text(comment.stringDate())),                      
                      Builder(builder: (value){
                        if (_user.user_id == comment.user_id){
                          return IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: (){
                              Future future = _getToken();
                              future.then((value){
                                Future future = RestApi.deleteComment(value, comment.id);
                                future.then((value){
                                  if (value["success"]){
                                    setState(() {});
                                  } else {
                                    return showDialog(
                                    context: context, 
                                    builder: (BuildContext context) {                          
                                    return AlertDialog(title: Text("Error"), content: Text(value["message"]));
                                    });                           
                                  }
                                });
                              });
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      })
                    ],),
                    subtitle: Text(comment.text),
                  ),
                  new Container(                    
                    height: 50.0,                 
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: comment.commentImages.length,
                      itemBuilder: (context, index) {
                      final commentImage = comment.commentImages[index];
                        return GestureDetector(
                          child: Image.network(RestApi.server + "/storage/" + commentImage.image_name),
                          onTap: (){
                              _showDialogImage(RestApi.server + "/storage/" + commentImage.image_name); 
                          },
                        ); 
                      }
                    )
                  ),
                ],
              )
            );
          }
        )
    );
  }

  _getExpandedEventImage(){
    return Expanded(
      child: Container(                                   
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _event.images.length,
          itemBuilder: (context, index) {
          final image = _event.images[index];
            return  GestureDetector(
              child: Image.network(RestApi.server + "/storage/" + image.image_name),
              onTap: (){
                _showDialogImage(RestApi.server + "/storage/" + image.image_name);                                  
              },  
            );
          }
        )
      )
    );
  }

  _getTextFormFieldComment(){   
    if (_user.user_id > 0) {
      final _formCommentKey = GlobalKey<FormState>();
      String _comment;
        return Form(
        key: _formCommentKey,
        child: Container(
        child: Column(
          children: <Widget>[
          //область для отображения изрбражений
          // Expanded (
          //   flex: 2,              
          //   child:Builder(
          //     builder:(value){
          //       if (_images.length <= 0){
          //         return SizedBox();
          //       } else {
          //        return ListView.builder(
          //           scrollDirection: Axis.horizontal,                    
          //           itemCount: _images.length,
          //           itemBuilder: (context, index) {
          //           final image = _images[index];
          //             return  GestureDetector(
          //               child: Image.file(image),
          //               onTap: (){
          //                 _showDialogImageFile(image);                       
          //               },
          //             );
          //           }
          //         );
          //       }
          //     } 
          //   )            
          // ),
          Row(children: <Widget>[
            Expanded(
              flex: 3,
              child: TextFormField(
                validator: (value){
                  
                  },
                onSaved: (value){
                _comment = value;
              },
              decoration: InputDecoration(hintText: "Введите комментарий"),
              ),
            ),
            //кнопка для загрузки изображения
            // Expanded(
            //   flex: 1,
            //   child:IconButton(onPressed: () async {
            //     final File photo = await ImagePicker.pickImage(source: ImageSource.gallery);
            //     if (photo != null) {
            //         return showDialog(
            //             context: context, 
            //             builder: (BuildContext context) {                          
            //           return AlertDialog(
            //             title: Text("Изображение"), 
            //             content: Image.file(photo),
            //             actions: <Widget>[
            //               FlatButton(
            //               child: Text('Добавить'),
            //               onPressed: () {
            //                 setState(() {
            //                   _images.add(photo);
            //                   Navigator.of(context).pop();                                
            //                 });                              
            //               }),
            //             ],
            //           );
            //         });
            //     }          
            //     },
            //     icon: Icon(Icons.attach_file),
            //     color: Colors.black,
            //   ), 
            // ),
            Expanded(
              child: IconButton(                        
                onPressed: (){
                _formCommentKey.currentState.save();
                if (_formCommentKey.currentState.validate()){
                  Future future = _getToken();
                  future.then((value){
                    Future future = RestApi.addComment(value, _comment, _event.id);
                    future.then((value){
                      if (value["success"]) {
                        setState((){
                          //_images.clear(); очищение списка картинок
                        });
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
              color: Colors.black,
              icon: Icon(Icons.send),
              ),
            ),
          ],
          )
        ],
        ),
      )
    );
    } else {
      return SizedBox();
    }   
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Просмотр события")),
      body: Container(
        margin: EdgeInsets.all(8.0),
        
        child: FutureBuilder(
          future: RestApi.getEventResponse(_event_id),
          builder: (context, snapshotEvent){          
          if (snapshotEvent.hasData){
            _event = ModelEvent.fromJson(snapshotEvent.data["data"]);            
            return FutureBuilder(
              future: _getToken(),
              builder: (context, snapshotToken){
                if (snapshotToken.hasData){                  
                  return FutureBuilder(
                    future: RestApi.getProfileResponse(snapshotToken.data),
                    builder: (context, snapshotUser) {
                      if (snapshotUser.hasData){                        
                        if (snapshotUser.data["success"]){
                          _user = _user = ModelUser.fromJson(snapshotUser.data["data"]);
                        } 
                        if ((_user.user_id == _event.user_id) && (_event.status_id == 1)) {  
                          return Column(
                            children: <Widget>[
                              _eventInformationEditWidget(),
                              _getExpandedEventImage(),
                              _getExpandedComments(),
                              _getTextFormFieldComment()
                            ],
                          );                       
                          
                        } else {
                          return Column(
                            children: <Widget>[
                              _eventInformationNotEditWidget(),
                              _getExpandedEventImage(),
                              _getExpandedComments(),
                              _getTextFormFieldComment()
                            ],
                          );
                        }
                      } else {
                        return Center (
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                } else {
                  return Center (
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return Center (
              child: CircularProgressIndicator(),
            );
          }
          },
        )
      ),
    );
  }
}