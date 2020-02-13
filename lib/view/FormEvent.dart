import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/model/Comment.dart';
import 'package:smart_city/model/Event.dart';

class CommentsState extends State {
  @override
  Widget build(BuildContext context) {
    return null;
  }

}

class FormEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormEventState();
  }
}

class FormEventState extends State<FormEvent> {

  final _formKey = GlobalKey<FormState>();

  static Event event = new Event(1, "Событие всех событий", 
                                "Описание события не должно быть слишком большим, а не то будет бобо и нехорошо",  
                                65.123234, 55.132435, "02.03.1990", "02.03.1990", 2, "statusName", 4, "useremail@yandex.ru");

  static List<Comment> comments = [
    new Comment.three("email1", '02.02.1999', 'text text text'),
    new Comment.three("email", "02.05.1999", "text text text"),
    new Comment.three("email", "02.05.1999", "text text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text text"),
    new Comment.three("email", "02.05.1999", "text text text"),
    new Comment.three("email", "02.05.1999", "text text text"),
    new Comment.three("email", "02.05.1999", "text text text"),
    new Comment.three("email", "02.05.1999", "text text text"),
    new Comment.three("email", "02.05.1999", "text text text"),
    new Comment.three("email", "02.05.1999", "text text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text texttext text text"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.eventName)),
      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Form(key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: <Widget>[
                    Text(event.eventDescription),
                    Text(event.latitude.toString()),
                    Text(event.longitude.toString()),
                    Text(event.eventDate),
                    Text(event.statusName),
                    Text(event.email),
                  ],
                ),
              ), 
              new Expanded(
                child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Card(
                      child: ListTile(
                        title: Text(comment.email + " " + comment.date),
                        subtitle: Text(comment.text),
                      ),
                    );
                  }),)       
            ]
          ), 
      ),
    );
  }
}