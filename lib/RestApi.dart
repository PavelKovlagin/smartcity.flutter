import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_city/model/Comment.dart';
import 'package:smart_city/model/Event.dart';

class RestApi {
  static String server = 'http://95.66.217.238:777'; 

  static Future _getResponse(String link) async{
    try{
      var res = await http.get(link);
      print("..." + res.body);
      if (res.statusCode == 200 || res.statusCode == 418) {
        return json.decode(res.body);
      } else {
        return null;
      }   
    } catch (Exception){      
     return null;
   }   
  }

  static Future getEventsResponse(String date)  {
    return _getResponse(server + "/api/events?dateChange=" + date);        
  }

  static Future getEventResponse(String event_id) {
    return _getResponse(server + "/api/event?event_id=" + event_id);
  }

  static Future<List<Event>> getEventResponse2(String event_id) async {
    List<Event> events;
    String link = server +'event?event_id=' + event_id;
    var res = await http.get(Uri.encodeFull(link));
        print(res.body);
    if (res.statusCode == 200) {

      // If the server did return a 200 OK response, then parse the JSON.
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      events = rest.map<Event>((json)=>Event.fromJson(json)).toList();
      print("List Size: ${events.length}");
    }     
    return events;
  }
    
  static Future<List<Event>> getEvents(String date) async {
    List<Event> events = new List<Event>();
    String link = server + "events?dateChange=" + date;
    try{
      var res = await http.get(link);
      print(res.body);

      if (res.statusCode == 200 || res.statusCode == 418) {
        var response = json.decode(res.body);
        var success = response["success"] as bool;
        var data = response["data"];
        var message = response["message"];
        switch (res.statusCode) {
          case 200:
            // If the server did return a 200 OK response, then parse the JSON.
            print("Success === " + success.toString());
            print("Data === ");
            print("Message ==== " + message.toString());
            events = data.map<Event>((json)=>Event.fromJson(json)).toList();
            print("List Size: ${events.length}");
            break;
          case 418:
            print("Success: " + success.toString() + ", Message: " + message.toString());
        }
      }   
    } catch (Exception){
     print("false load");
   }
    return events;


    //response
    
    // if (res.statusCode == 200) {
    //   // If the server did return a 200 OK response, then parse the JSON.
    //   var data = json.decode(res.body);
    //   var rest = data["data"] as List;
    //   print(rest);
    //   events = rest.map<Event>((json)=>Event.fromJson(json)).toList();
    //   print("List Size: ${events.length}");      
    // } 
          
  }

  static Future<List<Event>> getEvent(String event_id) async {
    List<Event> events;
    String link = server +'event?event_id=' + event_id;
    var res =
        await http.get(Uri.encodeFull(link));
        print(res.body);
    if (res.statusCode == 200) {

      // If the server did return a 200 OK response, then parse the JSON.
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      events = rest.map<Event>((json)=>Event.fromJson(json)).toList();
      print("List Size: ${events.length}");
    }     
    return events;
  }

  static Future<List<Comment>> getComments(String event_id) async {
    List<Comment> comments;
    String link = server + 'eventComments?event_id=' + event_id;
    var res =
        await http.get(Uri.encodeFull(link));
        print(res.body);
    if (res.statusCode == 200) {

      // If the server did return a 200 OK response, then parse the JSON.
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      comments = rest.map<Comment>((json)=>Comment.fromJson(json)).toList();
      print("List Size: ${comments.length}");
    } 
    
    return comments;
  }
}
