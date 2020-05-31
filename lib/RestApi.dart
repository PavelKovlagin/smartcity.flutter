import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_city/model/ModelComment.dart';
import 'package:smart_city/model/ModelEvent.dart';

class RestApi {
  static String server = 'http://95.66.217.238:777'; 

  static _currentResponse(bool success, String data, String message){
    return {
      "success": success,
      "data": data,
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

  static Future getProfileResponse(String token) async {
    try{
      Map<String, String> headers = {
        "Authorization": "Bearer " + token,
         "Accept": "application/json"
      };
      var res = await http.get(server + "/api/profile", headers: headers);
      print("..." + res.body);
      if (res.statusCode == 200 || res.statusCode == 418) {
        return json.decode(res.body);
      } 
      if (res.statusCode == 401) {        
        return _currentResponse(false, "[]", "Unauthenticated");
      } 
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
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
        return _currentResponse(false, "[]", "Unauthenticated");
      } 
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future getOauthClient() async{
    try{
      var res = await http.get(server + "/api/getOauthClient");
      print("..." + res.body);
      if (res.statusCode == 200 || res.statusCode == 418) {
        return json.decode(res.body);
      } 
      if (res.statusCode == 401) {        
        return _currentResponse(false, "[]", "Unauthenticated");
      } 
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future getToken(String username, String password, int client_id, String client_secret) async{
    try{
      Map<String, String> param = {
        "username": username,
        "password": password,
        "grant_type": "password",
        "client_id": client_id.toString(),
        "client_secret": client_secret
      };
      var res = await http.post(server + "/oauth/token",body: param);
      print("..." + res.body);
      print("CODE RESPONSE: " +res.statusCode.toString());
      if (res.statusCode == 200 || res.statusCode == 418) {      
        return _currentResponse(true, jsonDecode(res.body)["access_token"],  "OK");
      } 
      if (res.statusCode == 401) {        
        return _currentResponse(false, "[]", "Unauthenticated");
      }
      if (res.statusCode == 400) {
        return _currentResponse(false, "[]", "Invalid username or password");
      } 
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "TRY");
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
