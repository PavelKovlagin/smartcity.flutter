// class EventsList{
//   final List<Event> events;

//   EventsList(this.events);

//   factory EventsList.fromJson(List<dynamic> json) {
//     List<Event> events = new List<Event>();
//     events = json.map((i)=>Event.fromJson(i)).toList();
//     return new EventsList(events);
//   }
// }

class Event{

  int _event_id;
  String _eventName;
  String _eventDescription;
  double _latitude;
  double _longitude;
  String _eventDate;
  String _dateChange;
  int _status_id;
  String _statusName;
  int _user_id;
  String _email;

  Event(int event_id, 
        String eventName, 
        String eventDescription, 
        double latitude, 
        double longitude, 
        String eventDate, 
        String dateChange, 
        int status_id, 
        String statusName, 
        int user_id,
        String email) {
    _event_id = event_id;
    _eventName = eventName;
    _eventDescription = eventDescription;
    _latitude = latitude;
    _longitude = longitude;
    _eventDate = eventDate;
    _dateChange = dateChange;
    _status_id = status_id;
    _statusName = statusName;
    _user_id = user_id;
    _email = email;
  }

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      json["event_id"],
      json["eventName"],
      json["eventDescription"],
      json["latitude"],
      json["longitude"],
      json["eventDate"],
      json["dateChange"],
      json["status_id"],
      json["statusName"],
      json["user_id"],
      json["email"]
    ); 
  }

  get event_id => _event_id;

  set evetn_id(value) {
    _event_id = value;
  }

  get eventName => _eventName;

  set eventName(value) {
    _eventName = value;
  }

  get eventDescription => _eventDescription;

  set eventDescription(value){
    _eventDescription = value;
  }

  get latitude => _latitude;

  set latitude(value){
    _latitude = value;
  }

  get longitude => _longitude;

  set longitude(value){
    _longitude = value;
  }

  get eventDate => _eventDate;

  set eventDate(value){
    _eventDate = value;
  }

  get dateChange => _dateChange;

  set dateChange(value){
    _dateChange = value;
  }

  get status_id => _status_id;

  get statusName => _statusName;

  get user_id => _user_id;

  get email => _email; 
}