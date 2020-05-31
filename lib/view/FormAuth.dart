import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelUser.dart';

class FormAuth extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return FormAuthState();
  }
}

class FormAuthState extends State<FormAuth> {

  var _usualTextStyle = TextStyle(fontSize: 16, color: Colors.black);
  var _errorTextStyle = TextStyle(fontSize: 22, color: Colors.red);
  var _successTextStype = TextStyle(fontSize: 22, color: Colors.green);
 
  final _formKey = GlobalKey<FormState>();
  SharedPreferences preferences;

  Future<String> _getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("token");
  }

  _setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
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
                            _setToken(value["data"]);                            
                          });
                        }
                        print(value["message"]);
                      }); 
                    });                  
                    
                  }                    
                  }, child: Text('Авторизоваться'),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
                InkWell(
                  onTap: (){
                    print("Зарегистрироваться");
                  },
                  child: Text("Зарегистрироваться"),
                )
              ],
            ),
          ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Профиль"),
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.all(8.0),
        child: _getAuthWidget()
        )
      ),
    );
  }
}