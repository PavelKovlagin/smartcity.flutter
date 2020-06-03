import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
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
  }

  static Future getStatuses() async{
    try{
      Map<String, String> accept = {
        "Accept": "application/json"
      };
      var res = await http.get(server + "/api/statuses", headers: accept);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future getCategories() async{
    try{
      Map<String, String> heared = {
        "Accept": "application/json"
      };
      var res = await http.get(server + "/api/categories", headers: heared);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future updateUser(String token, int user_id, String surname, String name, String subname, DateTime date) async{
    try{
      Map<String, String> heared = {
        "Accept": "application/json",
        "Authorization": "Bearer " + token
      };
      Map<String, String> body = {
        "user_id" : user_id.toString(),
        "surname" : surname,
        "name" : name,
        "subname" : subname,
        "date" : date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString()
      }; 
      var res = await http.post(server + "/api/updateUser", headers: heared, body: body);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future register(String surname, String name, String subname, DateTime date, String email, String password, String c_password) async{
    try{
      Map<String, String> body = {
        "surname" : surname,
        "name" : name,
        "subname" : subname,
        "date" : date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString(),
        "email" : email,
        "password" : password,
        "c_password" : c_password
      }; 
      var res = await http.post(server + "/api/register", body: body);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future sendCode(String email) async{
    try{
      Map<String, String> body = {
        "email" : email,
      }; 
      var res = await http.post(server + "/api/sendCode", body: body);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future passwordChange(String email, String code_reset_password, String password, String password_confirm) async{
    try{
      Map<String, String> body = {
        "email" : email,
        "code_reset_password" : code_reset_password,
        "password" : password,
        "password_confirm" : password_confirm
      }; 
      var res = await http.post(server + "/api/passwordChange", body: body);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future addComment(String token, String comment, int event_id, List<File> images) async{
    try{      
      Map<String, String> header = {
        "Authorization" : "Bearer " + token,
        "Accept" : "application/json"
      };
      Map<String, dynamic> body = {
        "comment" : comment,
        "event_id" : event_id.toString(),
      }; 
      var res = await http.post(server + "/api/addComment", headers: header, body: body);
      print(json.decode(res.body));
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (e){      
      print("EXC " + e.toString());
     return _currentResponse(false, "[]", "Exception");
   }  
  }

  static Future deleteComment(String token, int comment_id) async{
    try{
      Map<String, String> header = {
        "Authorization" : "Bearer " + token,
        "Accept" : "application/json"
      };
      Map<String,  String> body = {
        "comment_id" : comment_id.toString(),
      }; 
      var res = await http.post(server + "/api/deleteComment", headers: header, body: body);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }

  static Future updateEvent(String token, int event_id,  String eventName, String eventDescription, double longitude, double latitude, int category_id) async{
    try{
      Map<String, String> header = {
        "Authorization" : "Bearer " + token,
        "Accept" : "application/json"
      };
      Map<String,  String> body = {
        "event_id" : event_id.toString(),
        "eventName" : eventName,
        "eventDescription" : eventDescription,
        "longitude" : longitude.toString(),
        "latitude" : latitude.toString(),
        'category_id' : category_id.toString()
      }; 
      var res = await http.post(server + "/api/updateEvent", headers: header, body: body);
      if (res.statusCode == 200 || res.statusCode == 418) return json.decode(res.body);
      if (res.statusCode == 401) return _currentResponse(false, "[]", "Unauthenticated");
      if (res.statusCode == 429) return _currentResponse(false, "[]", "Too Many Requests");
      return _currentResponse(false, "[]", "Error load");
    } catch (Exception){      
     return _currentResponse(false, "[]", "Error load");
   }  
  }
}
