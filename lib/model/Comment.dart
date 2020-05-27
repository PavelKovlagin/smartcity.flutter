import 'ModelImage.dart';

class Comment {

  Comment(List<ModelImage> commentImages, String email, String date, String text) {
    this._commentImages = commentImages;
    this._email = email;
    this._date = date;
    this._text = text;
  }

  factory Comment.fromJson(Map<String, dynamic> json){
    print(json["commentImages"]);
    return Comment(
      json["commentImages"].map<ModelImage>((json)=>ModelImage.fromJson(json)).toList(),
      json["email"],
      json["dateTime"],
      json["text"],
    ); 
  }

  String _email;
  String _date;
  String _text;
  List<ModelImage> _commentImages;

  String get email => _email;
  List<ModelImage> get commentImages => _commentImages;

  set email(String value) {
    _email = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }
  
  String get text => _text;

  set text(String value) {
    _text = value;
  }

}