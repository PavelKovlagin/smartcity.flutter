import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smart_city/model/User.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {



  User user = new User();

  final _formKey = GlobalKey<FormState>();
  var _todayDate = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    user.date = _todayDate.year.toString()+"."+_todayDate.month.toString()+"."+_todayDate.day.toString();
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
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
                  initialValue: "blablabla",
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
              user.password = value;
              },
              decoration: InputDecoration(labelText: "Password"),
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
                user.name = value;
              },
              initialValue: user.name,
              decoration: InputDecoration(labelText: "Имя"),
            ),
            new TextFormField(
              onSaved: (String value) {
                user.subname = value;
              },
              decoration: InputDecoration(labelText: "Отчество"),
            ),
                Row(children: <Widget>[
                  Text(user.date),
                  SizedBox(width: 20.0),
                  new RaisedButton(onPressed: (){
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1800, 1, 1),
                        maxTime: DateTime(3000, 12, 31),
                        onConfirm: (date) {
                          setState(() {
                            _todayDate = date;
                          });},
                        currentTime: _todayDate, locale: LocaleType.ru);
                  }, child: Text("Выбрать дату"),
                  ),
                ],
                ),
            new SizedBox(height: 20.0),
            new RaisedButton(onPressed: (){
              _formKey.currentState.save();
              if (_formKey.currentState.validate())
                return showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                  return AlertDialog(title: Text("Проверка"), content: Text(user.toString()),
                  );
                });
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