
class ModelUser {

  int _user_id;
  String _user_name;
  String _surname;
  String _subname;
  String _date;
  String _email;
  String _blockDate;
  bool _blocked;

  ModelUser.empty(){

  }

  ModelUser(int user_id, 
            String user_name, 
            String surname, 
            String subname, 
            String date,
            String email,
            String blockDate,
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
    return ModelUser(
      json['user_id'] as int,
      json['user_name'] as String,
      json['surname'] as String,
      json['subname'] as String,
      json['date'] as String,
      json['email'] as String,
      json['blockDate'] as String,
      json['blocked'] as bool
    );
  }

  int get user_id => _user_id;
  String get user_name => _user_name;
  String get surname => _surname;
  String get subname => _subname;
  String get date => _date;
  String get email => _email;
  String get blockDate =>  _blockDate;
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

  set date(String value) {
    _date = value;
  }

  set email(String value) {
    _email = value;
  }

  set blockDate(String value) {
    _blockDate = value;
  }

  set blocked(bool value) {
    _blocked = value;
  }
  
  @override
  String toString() {
    return _email + " " +_surname + " " + _user_name + " " +_subname + " " + _date;
  }
}