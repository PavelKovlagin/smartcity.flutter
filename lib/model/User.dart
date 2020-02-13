
class User {

  String _email;
  String _password;
  String _surname;
  String _name;
  String _subname;
  String _date;

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get subname => _subname;

  set subname(String value) {
    _subname = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get surname => _surname;

  set surname(String value) {
    _surname = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  @override
  String toString() {
    return _email + " " +_surname + " " + _name + " " +_subname + " " + _date;
  }
}