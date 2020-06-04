import 'package:smart_city/model/ModelEvent.dart';

class ModelUser {

  int _user_id;
  String _user_name = "asd";
  String _surname = "asd";
  String _subname = "asd";
  DateTime _date;
  String _email;
  DateTime _blockDate;
  bool _blocked;
  List<ModelEvent> _events;

  ModelUser.empty(){
    _user_id = 0;
    _user_name = "";
    _surname = "";
    _date = DateTime.now();
    _email = "";
    _blockDate = DateTime.parse('0000-01-01');
    _blocked = false;
    _events = new List<ModelEvent>();
  }

  ModelUser(int user_id, 
            String user_name, 
            String surname, 
            String subname, 
            DateTime date,
            String email,
            DateTime blockDate,
            bool blocked,
            List<ModelEvent> events) {
    _user_id = user_id;
    _user_name = user_name;
    _surname = surname;
    _subname = subname;
    _date = date;
    _email = email;
    _blockDate = blockDate;
    _blocked = blocked;
    _events = events;
  }

  factory ModelUser.fromJson(Map<String, dynamic> json){
    DateTime date;
    String user_name, surname, subname;
    if (json['user']['user_name'] == null) user_name = ""; else user_name = json['user']['user_name'];
    if (json['user']['surname'] == null) surname = ""; else surname = json['user']['surname'];
    if (json['user']['subname'] == null) subname = ""; else subname = json['user']['subname'];
    if (json['user']["date"] == null) {
      date = DateTime.now();      
    } else {
      date = DateTime.parse(json['user']["date"]);      
    }
    print(date);
    return ModelUser(
      json['user']['user_id'] as int,
      user_name,
      surname,
      subname,
      date,
      json['user']['email'] as String,
      DateTime.parse(json['user']['blockDate']),
      json['user']['blocked'] as bool,
      json['events'].map<ModelEvent>((json)=>ModelEvent.fromJson(json)).toList(),
    );
  }

  int get user_id => _user_id;
  String get user_name => _user_name;
  String get surname => _surname;
  String get subname => _subname;
  DateTime get date => _date;
  String get email => _email;
  DateTime get blockDate =>  _blockDate;
  bool get blocked => _blocked;
  List<ModelEvent> get events => _events;

  set user_id(int value) {
    _user_id = value;
  }

  set user_name(String value) {
    _user_name = value;
  }

  set surname(String value) {
    _surname = value;
  }

  set subname(String value) {
    _subname = value;
  }

  set date(DateTime value) {
    _date = value;
  }

  set email(String value) {
    _email = value;
  }

  set blockDate(DateTime value) {
    _blockDate = value;
  }

  set blocked(bool value) {
    _blocked = value;
  }
  
  String stringBlockDate(){
    return _blockDate.day.toString() + '.' + _blockDate.month.toString() + '.' + _blockDate.year.toString(); 
  }

  String stringDate() {
    return _date.day.toString() + '.' + _date.month.toString() + '.' + _date.year.toString(); 
  }

  @override
  String toString() {
    return _email + " " +_surname + " " + _user_name + " " +_subname + " " + stringDate();
  }
}