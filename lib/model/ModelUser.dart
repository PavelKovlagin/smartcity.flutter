
class ModelUser {

  int _user_id;
  String _user_name;
  String _surname;
  String _subname;
  DateTime _date;
  String _email;
  DateTime _blockDate;
  bool _blocked;

  ModelUser.empty(){
    _user_id = 0;
    _user_name = "";
    _surname = "";
    _date = DateTime.parse('0000-01-01');
    _email = "";
    _blockDate = DateTime.parse('0000-01-01');
    _blocked = false;
  }

  ModelUser(int user_id, 
            String user_name, 
            String surname, 
            String subname, 
            DateTime date,
            String email,
            DateTime blockDate,
            bool blocked) {
    _user_id = user_id;
    _user_name = user_name;
    _surname = surname;
    _subname = subname;
    _date = date;
    _email = email;
    _blockDate = blockDate;
    _blocked = blocked;
  }

  factory ModelUser.fromJson(Map<String, dynamic> json){
    DateTime date;
    print(json["date"]);
    if (json["date"] == null) {
      date = DateTime.now();      
    } else {
      date = DateTime.parse(json['date']);      
    }
    print(date);
    return ModelUser(
      json['user_id'] as int,
      json['user_name'] as String,
      json['surname'] as String,
      json['subname'] as String,
      date,
      json['email'] as String,
      DateTime.parse(json['blockDate']),
      json['blocked'] as bool
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