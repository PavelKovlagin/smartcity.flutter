import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_city/model/EventModel.dart';

class RestApi {
  static Future<List<Event>> getEvent() async {
  List<Event> events;
  String link = 'http://192.168.43.135:8000/api/event?event_id=1';
  var res =
      await http.get(Uri.encodeFull(link));
      print(res.body);
  if (res.statusCode == 200) {

    // If the server did return a 200 OK response, then parse the JSON.
    var data = json.decode(res.body);
    var rest = data as List;
    print(res);
    events = rest.map<Event>((json)=>Event.fromJson(json)).toList();
  } 
  print("List Size: ${events.length}");
  return events;
}
}
