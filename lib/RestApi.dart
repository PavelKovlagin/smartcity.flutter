import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_city/model/ModelComment.dart';
import 'package:smart_city/model/ModelEvent.dart';

class RestApi {
  static String server = 'http://95.66.217.238:777'; 

  static _currentResponse(bool success, String message){
    return {
      "success": success,
      "data": "[]",
      'message': message
    };
  }

  static Future getEventsResponse(String date) async {
    try{
      var res = await http.get(server + "/api/events?dateChange=" + date);
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

  static Future getEventResponse(String event_id) async {
    try{
      var res = await http.get(server + "/api/event?event_id=" + event_id);
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

  static Future getProfileResponse() async {
    try{
      Map<String, String> headers = {
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiYjk4YjM4MGMyMDY2ZjRmZjI2MTFkNTA5NDA1NWY3YTg5ZTgyMTBmMDg5NDY5MGRhZjQ3MmVjY2E5YWY5Njk3YTE5MDdhZDNlMTVlOWNiM2YiLCJpYXQiOjE1OTA2NzI5NjUsIm5iZiI6MTU5MDY3Mjk2NSwiZXhwIjoxNTkxOTY4OTY1LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.6Ir7VLITP1ZhrvIHHmkuLuIoNHebTgj1TI8wXW-OexaXlaqnEK4Yz8NId7BgEwvpc3PJzFd-KCddIbteRZX0mmdlKkA1FTF6TLBxeNrYIk_eyE2ZFX_B3JiNdb3r5Lm-RaBV0MDkK0u8jhEP3-5s2Zj5QTeQzAfB2Tqs6ubOD6fagkn0TBb26-ep4ZE01XcztOEEndzJJrrslNGFTPXHamJO3sc1aunU-onH8u3CNfSHqBStKt1Nc9Zm2i0LHJ9nq3-duy5oyWMAVN52Q5cSCZ23nfKJWhSHLIOKjZoHY8Grg-yjmLgPXbmsO-oU043z8v1Zj3NKRb5IV9Uo2G_q7Mn184A1sgnEADABghW-xBlVGRech-saVPmtXOOmLrLNF5kEsnudqw38tmqhZ_BVWp7ulqA8C8CG_TpbmjtkRXi91H5pY3zXPuJphgb-o8N_j53hu8S7Z-8WzjBKIzQbw4-MfeHYhfXB0CJx7xPPSjrRDwWKI5JUYC-Ng4XVnuHrf4kfEnm46mGQhm86mnHCSPGL_1UMlSS5vqwxYehfwnobW5ZetxQGHhxfK8n0O2UQJZGGluPD3uaicj4jSWLdOaRluyOlTAt8mNO0cojHt5HxA78W4IoXzkT2s9hu34XRJpBz0l0lFd13nZrPwAk3w11SYSi6Y8QqIjFoGO1YNhI",
        "Accept": "application/json"
      };
      var res = await http.get(server + "/api/profile", headers: headers);
      print("..." + res.body);
      if (res.statusCode == 200 || res.statusCode == 418) {
        return json.decode(res.body);
      } 
      if (res.statusCode == 401) {        
        return _currentResponse(false, "Unauthenticated");
      } 
      return _currentResponse(false, "Error load");
    } catch (Exception){      
     return _currentResponse(false, "Error load");
   }  
  }

  static Future getUserResponse(String user_id) async {
    try{
      var res = await http.get(server + "/api/user/" + user_id );
      print("..." + res.body);
      if (res.statusCode == 200 || res.statusCode == 418) {
        return json.decode(res.body);
      } 
      if (res.statusCode == 401) {        
        return _currentResponse(false, "Unauthenticated");
      } 
      return _currentResponse(false, "Error load");
    } catch (Exception){      
     return _currentResponse(false, "Error load");
   }  
  }


  static Future<List<ModelEvent>> getEventResponse2(String event_id) async {
    List<ModelEvent> events;
    String link = server +'event?event_id=' + event_id;
    var res = await http.get(Uri.encodeFull(link));
        print(res.body);
    if (res.statusCode == 200) {

      // If the server did return a 200 OK response, then parse the JSON.
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      events = rest.map<ModelEvent>((json)=>ModelEvent.fromJson(json)).toList();
      print("List Size: ${events.length}");
    }     
    return events;
  }
    
  static Future<List<ModelEvent>> getEvents(String date) async {
    List<ModelEvent> events = new List<ModelEvent>();
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
            events = data.map<ModelEvent>((json)=>ModelEvent.fromJson(json)).toList();
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

  static Future<List<ModelEvent>> getEvent(String event_id) async {
    List<ModelEvent> events;
    String link = server +'event?event_id=' + event_id;
    var res =
        await http.get(Uri.encodeFull(link));
        print(res.body);
    if (res.statusCode == 200) {

      // If the server did return a 200 OK response, then parse the JSON.
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      events = rest.map<ModelEvent>((json)=>ModelEvent.fromJson(json)).toList();
      print("List Size: ${events.length}");
    }     
    return events;
  }

  static Future<List<ModelComment>> getComments(String event_id) async {
    List<ModelComment> comments;
    String link = server + 'eventComments?event_id=' + event_id;
    var res =
        await http.get(Uri.encodeFull(link));
        print(res.body);
    if (res.statusCode == 200) {

      // If the server did return a 200 OK response, then parse the JSON.
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      comments = rest.map<ModelComment>((json)=>ModelComment.fromJson(json)).toList();
      print("List Size: ${comments.length}");
    } 
    
    return comments;
  }
}
