import 'package:smart_city/model/ModelComment.dart';

import 'ModelImage.dart';

class ModelEvent{

  int _id;
  String _eventName;
  String _eventDescription;
  double _latitude;
  double _longitude;
  String _event_date;
  String _dateChange;
  int _status_id;
  String _statusName;
  int _category_id;
  String _categoryName;
  int _user_id;
  String _email;
  int _visibilityForUser;
  List<ModelComment> _comments;
  List<ModelImage> _images;

  ModelEvent.def(){
    
  }

  ModelEvent(int id, 
        String eventName, 
        String eventDescription, 
        double latitude, 
        double longitude, 
        String event_date, 
        String dateChange, 
        int status_id, 
        String statusName, 
        int category_id,
        String categoryName,
        int user_id,
        String email,
        int visibilityForUser,
        List<ModelComment> comments,
        List<ModelImage> images) {
    _id = id;
    _eventName = eventName;
    _eventDescription = eventDescription;
    _latitude = latitude;
    _longitude = longitude;
    _event_date = event_date;
    _dateChange = dateChange;
    _status_id = status_id;
    _statusName = statusName;
    _category_id = category_id;
    _categoryName = categoryName;
    _statusName = statusName;
    _user_id = user_id;
    _email = email;
    _visibilityForUser = visibilityForUser;
    _comments = comments;
    _images = images;
  }

  factory ModelEvent.fromJson(Map<String, dynamic> json){
    List<ModelComment> comments = new List<ModelComment>();
    List<ModelImage> images = null;
    if (json["comments"] != null) comments = json["comments"].map<ModelComment>((json)=>ModelComment.fromJson(json)).toList();
    if (json["eventImages"] != null) images = json["eventImages"].map<ModelImage>((json)=>ModelImage.fromJson(json)).toList();
    return ModelEvent(
      json["id"],
      json["eventName"],
      json["eventDescription"],
      json["latitude"].toDouble(),
      json["longitude"].toDouble(),
      json["event_date"],
      json["dateChange"],
      json["status_id"],
      json["statusName"],
      json["category_id"],
      json["categoryName"],
      json["user_id"],
      json["email"],
      json["visibilityForUser"],
      comments,
      images
    ); 
  }

  get id => _id;
  get eventName => _eventName;
  get eventDescription => _eventDescription;
  get latitude => _latitude;
  get longitude => _longitude;
  get event_date => _event_date;
  get dateChange => _dateChange;
  get status_id => _status_id;
  get statusName => _statusName;
  get category_id => _category_id;
  get categoryName => _categoryName;
  get user_id => _user_id;
  get email => _email;   
  get visibilityForUser => _visibilityForUser;
  List<ModelComment> get comments => _comments;
  List<ModelImage> get images => _images;

  set id(value) {
    _id = value;
  }  

  set catetoryName(value){
    _categoryName = value;
  }

  set eventName(value) {
    _eventName = value;
  }  

  set eventDescription(value){
    _eventDescription = value;
  } 

  set category_id(value){
    _category_id = value;
  } 

  set latitude(value){
    _latitude = value;
  }  

  set longitude(value){
    _longitude = value;
  }  

  set event_date(value){
    _event_date = value;
  }  

  set dateChange(value){
    _dateChange = value;
  }

  @override
  String toString() {
    // TODO: implement toString
    return _id.toString() + " " +
            _eventName + " " +
            _eventDescription + " " +
            _latitude.toString() + " " +
            _longitude.toString() + " " +
            _event_date + " " +
            _dateChange + " " +
            _status_id.toString() + " " +
            _statusName + " " +
            _category_id.toString() + " " +
            _categoryName + " " +
            _user_id.toString() + " " +
            _email + " " +
            _visibilityForUser.toString();
  }
}