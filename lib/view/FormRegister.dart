import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smart_city/RestApi.dart';
import 'package:smart_city/model/ModelUser.dart';

class FormRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FormRegisterState();
}

class FormRegisterState extends State<FormRegister> {

  ModelUser user = new ModelUser.empty();

  final _formKey = GlobalKey<FormState>();
  var _todayDate = new DateTime.now();
  String _password = "";
  String _c_password ="";
  

  @override
  Widget build(BuildContext context) {
    user.date = _todayDate;    
    return Scaffold(
      appBar: AppBar(
        title: Text("Регистрация")),
        body: SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.all(16.0),
            child: new Form(key: _formKey,
              child: new Column(children: <Widget>[
                new TextFormField(validator: (value){
                  if (value.isEmpty) return "Введите email";
                },
                  onSaved: (value) {
                  user.email = value;
                  },
                  decoration: InputDecoration( labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
            new TextFormField(validator: (value){
              if (value.length < 8) return "Пароль должен содержать не менее 8 символов";
            },
              onSaved: (value) {
              _password = value;
              },
              decoration: InputDecoration(labelText: "Password"),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            new TextFormField(validator: (value){
              if (value != _password) return "Пароли не совпадают";
            },
              onSaved: (value) {
              _c_password = value;
              },
              decoration: InputDecoration(labelText: "Confirm password"),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            new TextFormField(
              onSaved: (value) {
                user.surname = value;
              },
              decoration: InputDecoration(labelText: "Фамилия"),
            ),
            new TextFormField(
              onSaved: (value) {
                user.user_name = value;
              },
              initialValue: user.user_name,
              decoration: InputDecoration(labelText: "Имя"),
            ),
            new TextFormField(
              onSaved: (String value) {
                user.subname = value;
              },
              decoration: InputDecoration(labelText: "Отчество"),
            ),
            Row(children: <Widget>[
              Text(user.stringDate()),
              SizedBox(width: 20.0),
              new RaisedButton(onPressed: (){
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1800, 1, 1),
                    maxTime: DateTime(3000, 12, 31),
                    onConfirm: (date) {
                      setState(() {
                        _todayDate = user.date;
                      });},
                    currentTime: _todayDate, 
                    locale: LocaleType.ru);
              }, child: Text("Выбрать дату"),
              ),
            ],
            ),
            new SizedBox(height: 20.0),
            new RaisedButton(onPressed: (){              
              _formKey.currentState.save();
              if (_formKey.currentState.validate()){
                Future future = RestApi.register(user.surname, user.user_name, user.subname, user.date, user.email, _password, _c_password);
                future.then((value){
                    return showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                    return AlertDialog(title: Text("Проверка"), content: Text(value["message"]),
                    );
                  });           
                });  
              }                            
            }, child: Text('Проверить'),
              color: Colors.blue,
              textColor: Colors.white,)
          ],
          ),
          ),
          ),
        ),
    );
  }
}