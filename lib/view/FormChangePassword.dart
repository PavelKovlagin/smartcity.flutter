import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_city/RestApi.dart';

class FormChangePassword extends StatefulWidget {

  String _email;

  FormChangePassword(String email) {
    _email = email;
  }

  @override
  State<StatefulWidget> createState() => FormChangePasswordState(_email);
}

class FormChangePasswordState extends State<FormChangePassword> {

  FormChangePasswordState(String email){
    _email = email;    
  }

  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _codeReset = "";
  String _password = "";
  String _c_password = "";

  _changePasswordWidget(){
    return FutureBuilder(
      future: RestApi.sendCode(_email),
      builder: (context, snapshot){
        if (snapshot.hasData){
          if (snapshot.data["success"]){
            return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: new Form(key: _formKey,
                child: new Column(children: <Widget>[
                  Text("Код сброса отправлен на " + _email),
                  new TextFormField(validator: (value){
                    if (value.isEmpty) return "Введите email";
                  },
                    onSaved: (value) {
                    _email = value;
                    },
                    initialValue: _email,
                    decoration: InputDecoration( labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  new TextFormField(validator: (value){
                    if (value.isEmpty) return "Введите код сброса пароля";
                  },
                    onSaved: (value) {
                    _codeReset = value;
                    },
                    decoration: InputDecoration( labelText: "Code reset"),
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                  ),
                  new TextFormField(validator: (value){
                    if (value.length < 8) return "Пароль должен содержать не менее 8 символов";
                  },
                    onSaved: (value) {
                    _password = value;
                    },
                    decoration: InputDecoration( labelText: "Password"),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    maxLines: 1,
                  ),
                  new TextFormField(validator: (value){
                    if (value != _password) return "Пароль должен содержать не менее 8 символов";
                  },
                    onSaved: (value) {
                    _c_password = value;
                    },
                    decoration: InputDecoration( labelText: "Confirm password"),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    maxLines: 1,
                  ),
                  new SizedBox(height: 20.0),
                  new RaisedButton(onPressed: (){              
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate()){
                      Future future = RestApi.passwordChange(_email, _codeReset, _password, _c_password);
                      future.then((value){
                        return showDialog(
                            context: context, 
                            builder: (BuildContext context) {                          
                          return AlertDialog(title: Text("Отчет"), content: Text(value["message"]),
                          );
                        });
                      });                                     
                    }                            
                  }, child: Text('Изменить пароль'),
                    color: Colors.blue,
                    textColor: Colors.white,)
                ],
                ),
              ),
            ),
          );
          } else {        
            return Container(
              alignment: Alignment.center,
              child: Text(snapshot.data["message"])
            );
          } 
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      }
    );
  }  

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text("Изменение пароля")),
        body: _changePasswordWidget()
    );
  }
}