import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelComment.dart';
import 'package:smart_city/model/ModelEvent.dart';
import 'package:smart_city/model/ModelImage.dart';

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

  ModelEvent event = ModelEvent.def();
  List<ModelComment> comments = List<ModelComment>();
  List<ModelImage> images = List<ModelImage>();
  String _event_id;
  final _formKey = GlobalKey<FormState>();

  FormEventState(String event_id){
    this._event_id = event_id;
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

  _getExpandedEvent(){
    if (_event_id == "5"){
      return Expanded(   
      flex: 4,
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(validator: (value){
                if (value.isEmpty) return "Введите название события";
              },
              onSaved: (value){
                event.eventName = value;
              },
              initialValue: event.eventName,
              decoration: InputDecoration(labelText: "Название события"),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              ),
              TextFormField(validator: (value){
                if (value.isEmpty) return "Введите описание события";
              },
              onSaved: (value){
                event.eventDescription = value;
              },
              initialValue: event.eventDescription,
              decoration: InputDecoration(labelText: "Описание события"),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              
              ),
              TextFormField(validator: (value){
                if (value.isEmpty) return "Введите широту";
              },
              onSaved: (value){
                try {
                  event.latitude = double.parse(value);
                } catch (e) {
                  value = "0";
                  print("latitude not double");
                }                              
              },
              initialValue: event.latitude.toString(),
              decoration: InputDecoration(labelText: "Широта"),
              keyboardType: TextInputType.number,
              maxLines: null,                          
              ),
              TextFormField(validator: (value){
                if (value.isEmpty) return "Введите долготу";
              },
              onSaved: (value){
                try {
                  event.longitude = double.parse(value);
                } catch (e) {
                  print("longitude not double");
                }  
                //_longitude = double.parse(value);
              },
              initialValue: event.longitude.toString(),
              decoration: InputDecoration(labelText: "Долгота"),
              keyboardType: TextInputType.number,
              maxLines: null,
              ),
              Text("Статус события: " + event.statusName),
              Text("Пользователь: " + event.email),
            ],
          )
        )
      );
    } else {
      return Expanded(
        flex: 4,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text("Название события: " + event.eventName),
            Text("Описание события: " + event.eventDescription),
            Text("Статус события: " + event.statusName),
            Text("Пользователь: " + event.email),
            Text("Широта: " + event.latitude.toString()),
            Text("Долгота: " + event.longitude.toString()),
            ],
          ),  
        ),
      );
    }    
  }

  _getExpandedComments(){
    return Expanded(
      flex: 4,
      child: Container(
      height: 200,
        child: ListView.builder(                        
        itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return Card(
              child: Column (
                children: <Widget>[
                  
                  ListTile(
                    title: InkWell(
                      child: Text(
                        comment.email + " " + comment.date), 
                        onTap: () {
                          Navigator.pushNamed(context,'/profile/' + comment.user_id.toString()); 
                        },
                    ),
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
                  RaisedButton(
                    child: Icon(Icons.delete_forever),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      
                    },)
                ],
              )
            );
          }
        )
      ),
    );
  }

  _getExpandedEventImage(){
    return Expanded(
      flex: 2,
      child: Container(                                   
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
          final image = images[index];
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
    if (_event_id == "5") {
      return Expanded(
      flex: 1,
          child: Container (
          height: 200,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: 
                TextFormField(validator: (value){

              },
              decoration: InputDecoration(labelText: "Введите комменатий"),
              ),
              ),
              Expanded (
                flex: 1,
                  child: RaisedButton(                        
                  onPressed: (){
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate())
                      return showDialog(
                          context: context, 
                          builder: (BuildContext context) {
                        return AlertDialog(title: Text("Проверка"), content: Text(event.toString()),
                        );
                      }); 
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Icon(Icons.keyboard_return),
                ),
              )
            ],
          ),
        )
      );
    } else {
      return Expanded(
        flex: 0,
        child: Center(
          child: RaisedButton(
            child: Text("Чтобы отправлять комменатии необходимо авторизоваться"),
            color: Colors.blue,
            
            textColor: Colors.white,
            onPressed: (){
              Navigator.pushNamed(context,'/auth');
            }, 
          )
        )
      );
    }   
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Просмотр события")),
      body: Container(
        margin: EdgeInsets.all(8.0),
        
        child: FutureBuilder(
            future: RestApi.getEventResponse(_event_id.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data["success"] == false) {
                   return Center (
                     child: Text(snapshot.data["message"]
                     )
                   );
                } else {
                  event = ModelEvent.fromJson(snapshot.data["data"]["event"]);
                  comments = snapshot.data["data"]["comments"].map<ModelComment>((json)=>ModelComment.fromJson(json)).toList();
                  images = snapshot.data["data"]["event"]["eventImages"].map<ModelImage>((json)=>ModelImage.fromJson(json)).toList();
                  return Form(
                  key: _formKey,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[  
                      _getExpandedEvent(),
                      _getExpandedEventImage(),
                      _getExpandedComments(),
                      _getTextFormFieldComment()
                    ],
                  ),
                );
                }               
              } else {
                return Center(
                  child: CircularProgressIndicator());
              }
            },
          ),
      ),
    );
  }
}

class FormEventStateNonEdit extends State<FormEvent> {

  FormEventStateNonEdit(String event_id){
    this._event_id = event_id;
  }

  String _event_id;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Просмотр события")),
      body: Container(
        child: FutureBuilder(
            future: RestApi.getEventResponse(_event_id.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ModelEvent event = ModelEvent.fromJson(snapshot.data["data"]["event"]);
                List<ModelComment> comments = snapshot.data["data"]["comments"].map<ModelComment>((json)=>ModelComment.fromJson(json)).toList();
                List<ModelImage> images = snapshot.data["data"]["event"]["eventImages"].map<ModelImage>((json)=>ModelImage.fromJson(json)).toList();
                for (ModelComment comment in comments){
                  for (ModelImage commentImage in comment.commentImages){
                    print(commentImage.image_name);
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[  
                    
                    Expanded(
                      child: Container(                                     
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                          final image = images[index];
                            return  Container(
                              child: Image.network(RestApi.server + "/storage/" + image.image_name)
                            );
                          }
                        )
                      )
                    ),  
                    Expanded(
                      child: Container(
                      height: 200,
                        child: ListView.builder(                        
                        itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return Card(
                              child: Column (
                                children: <Widget>[
                                  ListTile(
                                    title: Text(comment.email + " " + comment.date),
                                    subtitle: Text(comment.text),
                                  ),
                                  new Container(                    
                                    height: 50.0,                 
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: comment.commentImages.length,
                                      itemBuilder: (context, index) {
                                      final commentImage = comment.commentImages[index];
                                        return  Container(
                                          child: Image.network("http://95.66.217.238:777//storage/" + commentImage.image_name)
                                        );
                                      }
                                    )
                                  )
                                ],
                              )
                            );
                          }
                        )
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator());
              }
            },
          ),
      ),
    );
  }
}
