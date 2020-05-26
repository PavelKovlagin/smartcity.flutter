import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/Comment.dart';
import 'package:smart_city/model/Event.dart';


class FormEvent extends StatefulWidget {
  
  Event event = null;

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

  FormEventState(String event_id){
    this._event_id = event_id;
  }

  String _event_id;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Просмотр события")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          FutureBuilder(
            future: RestApi.getEventResponse(_event_id.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Event event = Event.fromJson(snapshot.data["data"]["event"]);
                print(snapshot.data["data"]["comments"]);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[                    
                    Text("Называние события: " + event.eventName),
                    Text("Описание события: " + event.eventDescription),
                    Text("Статус события: " + event.statusName),
                    Text("Пользователь: " + event.email),
                    Text("Широта: " + event.latitude.toString()),
                    Text("Долгота: " + event.longitude.toString()),
                    Image.network(
                      "http://95.66.217.238:777/storage/2020.5.25 11-6-581.jpg",
                      height: 100,)
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),

          // new Expanded(
          //     child: FutureBuilder(
          //   future: RestApi.getComments("1"),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return ListView.builder(
          //           itemCount: snapshot.data.length,
          //           itemBuilder: (context, index) {
          //             final comment = snapshot.data[index];
          //             return Card(
          //               child: ListTile(
          //                 title: Text(comment.email + " " + comment.date),
          //                 subtitle: Text(comment.text),
          //               ),
          //             );
          //           });
          //     } else {
          //       return CircularProgressIndicator();
          //     }
          //   },
          // ))
        ]),
      ),
    );
  }
}
