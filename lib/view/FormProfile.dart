import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelUser.dart';

class FormProfile extends StatefulWidget{

  String _user_id;
  bool _myProfile;

  FormProfile(){
    _myProfile = true;
  }

  FormProfile.user_id(String user_id) {
    _user_id = user_id;
    _myProfile = false;
  }

  @override
  State<StatefulWidget> createState() {
    return FormProfileState(_user_id, _myProfile);
  }
}

class FormProfileState extends State<FormProfile> {

  FormProfileState(String user_id, bool myProfile) {
    _user_id = user_id;
    _myProfile = myProfile;
  }

  var _usualTextStyle = TextStyle(fontSize: 16, color: Colors.black);
  var _errorTextStyle = TextStyle(fontSize: 22, color: Colors.red);
  var _successTextStype = TextStyle(fontSize: 22, color: Colors.green);
 

  DateTime _date;
  String _user_id;
  bool _myProfile;
  final _formKey = GlobalKey<FormState>();
  SharedPreferences preferences;

  ModelUser _user;

  void _logout(){
    setState(() {  
      Future future = _removeToken(); 
      future.then((value){
        _user = null; 
      });                          
    });
  }

  Future<String> _getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("token") == null) {
      return "null";
    } else {
      return preferences.getString("token");
    } 
  }

  Future _setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
  }

  Future _removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('token');
  }

  _getUserInformationWidget(){
    return Column(
    children: <Widget>[
        Expanded(
        child: SingleChildScrollView (
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Builder(builder: (value){
                if (_user.blocked) {
                  return Text("Пользователь заблокирован до " + _user.stringBlockDate(), style: _errorTextStyle);
                } else {
                  return Text("Пользователь не заблокирован", style: _successTextStype); 
                }          
              },
              ),
              Text("Фамилия: " + _user.surname, style: _usualTextStyle),
              Text("Имя: " + _user.user_name, style: _usualTextStyle),
              Text("Отчество: " + _user.subname, style: _usualTextStyle),
              Text("Дата рождения: " + _user.stringDate(), style: _usualTextStyle),
              Text("Email: " + _user.email, style: _usualTextStyle),
            ],
          ),
        ),
      ),
        _getListEvent()
    ],
    ) ;
  }

  _getFutureBuilderProfileWidget(String token){
    return Container(
      child: Builder(
        builder: (value){
          if (token != "null"){
            if (_user == null) {
              return FutureBuilder(
              future: RestApi.getProfileResponse(token),
              builder: (context, snapshot) {
                if (snapshot.hasData ) {
                  if (snapshot.data["success"]) {
                    _user = ModelUser.fromJson(snapshot.data["data"]);
                    return _getProfileInformationWidget(_user);
                  } else {
                    return _getAuthWidget();
                  }              
                } else {
                  return Center(
                      child: CircularProgressIndicator());
                  }           
              }
              );
            } else {
              return _getProfileInformationWidget(_user);
            }
          } else {            
            return _getAuthWidget();
          }
        }
      )

      
    );    
  }

  _getAuthWidget(){
    String _email;
    String _password;
    String _c_password;
    return SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.all(16.0),
            child: new Form(key: _formKey,
              child: new Column(children: <Widget>[
                new TextFormField(validator: (value){
                  if (value.isEmpty) return "Введите email";
                },
                  onSaved: (value) {
                    _email = value;
                  },
                  decoration: InputDecoration( labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                new TextFormField(validator: (value){
                  if (value.isEmpty) return "Введите пароль";
                },
                  onSaved: (value) {
                    _password = value;
                  },
                  decoration: InputDecoration(labelText: "Password"),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                new TextFormField( validator: (value){
                  if (value.isEmpty) return "Введите подтверждение пароля";
                  if (value != _password) return "Пароли не совпадают";
                },
                  onSaved: (value) {
                    _c_password = value;
                  },
                  decoration: InputDecoration(labelText: "Confirm password"),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(height: 35),
                new RaisedButton(                  
                  onPressed: (){
                    _formKey.currentState.save();
                  if (_formKey.currentState.validate() && _password == _c_password) {
                    Future future = RestApi.getOauthClient();
                    future.then((value){
                      Future future = RestApi.getToken(_email, _password, value["data"]["id"], value["data"]["secret"]);
                      future.then((value){
                        if (!value["success"]) {                          
                          return showDialog(
                              context: context, 
                              builder: (BuildContext context) {                          
                            return AlertDialog(title: Text("Ошибочка"), content: Text(value["message"]),
                            );
                          });
                        } else {
                          setState(() {
                            _user = null;
                            _setToken(value["data"]);                            
                          });
                        }
                      }); 
                    });                  
                    
                  }                    
                  }, child: Text('Авторизоваться'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                SizedBox(height: 35),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text("Зарегистрироваться", style: TextStyle(color: Colors.blue)),
                ),
                SizedBox(height: 35),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/sendCode');
                  },
                  child: Text("Забыли пароль?", style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ),
          ),
        );
  }

  _getFutureBuilderUserWidget(){
    return FutureBuilder(
      future: RestApi.getUserResponse(_user_id),
      builder: (context, snapshot) {
        if (snapshot.hasData ) {
          if (snapshot.data["success"]) {
            _user = ModelUser.fromJson(snapshot.data["data"]);
            return _getUserInformationWidget();
          } else {
            return Text(snapshot.data["message"]);
          }              
        } else {
          return Center(
              child: CircularProgressIndicator());
          };            
      },          
    );
  }

  _getProfileInformationWidget(ModelUser user){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Form(
              key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Container(
                  alignment: Alignment.topRight,
                    child: RaisedButton(
                      child: Text("Выйти из профиля"),
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: (){
                        _logout();                                       
                      },
                    ),
                  ),
                  
                  Builder(builder: (value){           
                    if (user.blocked) {
                      return Text("Пользователь заблокирован до " + user.stringBlockDate(), style: _errorTextStyle);
                    } else {
                      return Text("Пользователь не заблокирован", style: _successTextStype); 
                    }          
                  },
                  ),
                  Text("Email: " + user.email, style: _usualTextStyle),
                  TextFormField(
                    onSaved: (value){
                      user.surname = value;
                    },
                    initialValue: user.surname,
                    decoration: InputDecoration(labelText: "Фамилия"),
                    maxLines: 1,
                  ),
                  TextFormField(
                    onSaved: (value){
                      user.user_name = value;
                    },
                    initialValue: user.user_name,
                    decoration: InputDecoration(labelText: "Имя"),
                    maxLines: 1,
                  ),
                  TextFormField(
                    onSaved: (value){
                      user.subname = value;
                    },
                    initialValue: user.subname,
                    decoration: InputDecoration(labelText: "Отчество"),
                    maxLines: 1,
                  ),
                  Row(children: <Widget>[                  
                    Text("Дата рождения: ", style: _usualTextStyle),
                    new RaisedButton(onPressed: (){
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1800, 1, 1),
                          maxTime: DateTime(3000, 12, 31),
                          onConfirm: (date) {
                            setState(() {
                              user.date = date; 
                            });
                          },
                          currentTime: user.date,
                          locale: LocaleType.ru);
                    }, child: Text(user.stringDate()),
                    ),
                  ],
                  ),                  
                  RaisedButton(
                    child: Text("Редактировать"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: (){
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()){
                        Future future = _getToken();
                        future.then((value){
                          Future future = RestApi.updateUser(value, user.user_id, user.surname, user.user_name, user.subname, user.date);
                          future.then((value){
                            return showDialog(
                                context: context, 
                                builder: (BuildContext context) {                          
                              return AlertDialog(title: Text("Отчет"), content: Text(value["message"]),
                              );
                            });
                          });
                        });                                                      
                      }                    
                    },
                  ),
                  ],
                ),
              )
          ),
          ),
          _getListEvent()
        ],
      ),
    );
  }

  _getListEvent(){
    return Expanded(
      flex: 1,
      child: ListView.builder(                        
      itemCount: _user.events.length,
        itemBuilder: (context, index) {
          final event = _user.events[index];
          return Card(
            child: ListTile(
                  title: Text(event.eventName), 
                  subtitle: Text(event.eventDescription),
                  onTap: (){
                    Navigator.pushNamed(context, '/event/' + event.id.toString()).then((value){
                      Future future = _getToken();
                      future.then((value){
                        Future future = RestApi.getProfileResponse(value);
                        future.then((value){
                          setState(() {
                            _user = ModelUser.fromJson(value["data"]);
                          });
                        }); 
                      });       
                    });
                  }
                ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Builder(
          builder: (value){
            if (_myProfile){
              return FutureBuilder(
                future: _getToken(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _getFutureBuilderProfileWidget(snapshot.data);
                  } else {
                    return Center(
                      child: CircularProgressIndicator()
                    );
                  }
                }
              );
            } else {
              return _getFutureBuilderUserWidget();
            }
          },
        ),
      )
    );
  }
}