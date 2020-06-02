import 'ModelImage.dart';

class ModelComment {

  int _user_id;
  String _email;
  DateTime _date;
  String _text;
  List<ModelImage> _commentImages;

  ModelComment(List<ModelImage> commentImages, int user_id, String email, DateTime date, String text) {
    this._commentImages = commentImages;
    this._user_id = user_id;
    this._email = email;
    this._date = date;
    this._text = text;
  }

  factory ModelComment.fromJson(Map<String, dynamic> json){
    print(json["commentImages"]);
    return ModelComment(
      json["commentImages"].map<ModelImage>((json)=>ModelImage.fromJson(json)).toList(),
      json["user_id"],
      json["email"],
      DateTime.parse(json["dateTime"]),
      json["text"],
    ); 
  }  

  int get user_id => _user_id;
  String get email => _email;
  List<ModelImage> get commentImages => _commentImages;

  set email(String value) {
    _email = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }
  
  String get text => _text;

  set text(String value) {
    _text = value;
  }

}