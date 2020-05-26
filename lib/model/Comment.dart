class Comment {

  Comment(String email, String date, String text) {
    this._email = email;
    this._date = date;
    this._text = text;
  }

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      json["email"],
      json["dateTime"],
      json["text"],
    ); 
  }

  String _email;
  String _date;
  String _text;

  String get email => _email;

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